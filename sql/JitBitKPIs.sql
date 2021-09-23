/*
 * This query selects data from a JitBit implementation, pulls data
 * that eventually are displayed with PowerBi to control and visualize
 * KPIs and metrics in a helpdesk environment.
 */

SELECT
    issue.IssueID AS Issue,
    iStatus.Name AS [Status],
    iSLA.Value AS [SLA Plan],
    iSections.Name AS [Service],
    iCategories.Name AS Category,
    issue.IssueDate AS Created,
    issue.DueDate AS Due,
    rCompanies.Name AS Company,
    CONCAT(iRequester.FirstName, ' ', iRequester.LastName) AS Requester,
    issue.StartDate AS Taken,
    CONCAT(iTech.FirstName, ' ', iTech.LastName) AS Technician,
    tDepartments.Name AS [Tech Department],
    issue.TimesReopened AS [Reopen Counter],
    issue.ResolvedDate AS Resolved,
    extRepCounter.rCounter AS [Public Replies],
    intRepCounter.rCounter AS [Private Replies],
    repCounter.rCounter AS [Total Interactions],
    DATEDIFF(MINUTE, issue.IssueDate, issue.ResolvedDate) as [Resolution Time],    
    CASE
        -- When the ticket is older thant the first comment
        WHEN (issue.IssueDate < iComments.firstComment)
            -- Process the difference between issue date and first comment (private and public comments)
            THEN DATEDIFF(MINUTE,issue.IssueDate, iComments.firstComment)
        -- When the ticket is newer than the first comment
        ELSE DATEDIFF(MINUTE, issue.IssueDate, rFirstComment.rFirstComment)
    END AS [First Contact Time],    
    CASE
        WHEN CONVERT(VARCHAR, issue.priority) = '-1' THEN 'Low'
        WHEN CONVERT(VARCHAR, issue.priority) = '0' THEN 'Normal'
        WHEN CONVERT(VARCHAR, issue.priority) = '1' THEN 'High'
        WHEN CONVERT(VARCHAR, issue.priority) = '2' THEN 'Critical'
    END AS Priority,
    iImpact.Value AS Impact,    
    CASE
        WHEN CONVERT(VARCHAR, issue.origin) = '0' THEN 'Service Desk'
        WHEN CONVERT(VARCHAR, issue.origin) = '1' THEN 'Email'
        WHEN CONVERT(VARCHAR, issue.origin) = '2' THEN 'Widget'
        WHEN CONVERT(VARCHAR, issue.origin) = '3' THEN 'Cust Portal'
        WHEN CONVERT(VARCHAR, issue.origin) = '4' THEN 'Scheduler'
        WHEN CONVERT(VARCHAR, issue.origin) = '6' THEN 'Phone'
    END AS Origin     
FROM hdIssues issue
INNER JOIN (
    SELECT 
        iCustFieldVals.IssueID, iCustFieldVals.Value
    FROM hdCustomFieldValues iCustFieldVals 
    WHERE iCustFieldVals.FieldID = 3
) iSLA ON iSLA.IssueID = issue.IssueID
INNER JOIN (
    SELECT 
        iCustFieldVals.IssueID, iCustFieldVals.Value
    FROM hdCustomFieldValues iCustFieldVals 
    WHERE iCustFieldVals.FieldID = 2
) iImpact ON iImpact.IssueID = issue.IssueID
INNER JOIN hdStatus iStatus ON iStatus.StatusID = issue.StatusID
INNER JOIN hdCategories iCategories ON iCategories.CategoryID = issue.CategoryID
INNER JOIN hdSections iSections ON iSections.SectionID = iCategories.SectionID
INNER JOIN hdUsers iRequester ON iRequester.UserID = issue.UserID
INNER JOIN hdUsers iTech ON iTech.UserID = issue.AssignedToUserID
INNER JOIN hdCompanies rCompanies ON rCompanies.CompanyID = iRequester.CompanyID
LEFT JOIN Departments tDepartments ON tDepartments.DepartmentID = iTech.DepartmentID
INNER JOIN (
    SELECT comments.issueID, COUNT(*) AS rCounter 
    FROM hdComments comments 
    WHERE comments.IsSystem = 0 and comments.ForTechsOnly = 0
    GROUP BY comments.IssueID
) extRepCounter ON extRepCounter.IssueID = issue.IssueID
INNER JOIN (
    SELECT comments.issueID, COUNT(*) AS rCounter 
    FROM hdComments comments 
    WHERE comments.IsSystem = 0 and comments.ForTechsOnly = 1
    GROUP BY comments.IssueID
) intRepCounter ON intRepCounter.IssueID = issue.IssueID
INNER JOIN (
    SELECT comments.issueID, COUNT(*) AS rCounter 
    FROM hdComments comments 
    WHERE comments.IsSystem = 0
    GROUP BY comments.IssueID
) repCounter ON repCounter.IssueID = issue.IssueID
INNER JOIN (
    SELECT hdComments.IssueID, MIN(hdComments.CommentDate) AS firstComment
    FROM hdComments 
    WHERE IsSystem = 0 
    GROUP BY hdComments.IssueID
) iComments ON iComments.IssueID = issue.IssueID
INNER JOIN (
    SELECT hdComments.IssueID, MIN(hdComments.CommentDate) AS rFirstComment
    FROM hdComments
    INNER JOIN hdIssues on hdIssues.IssueID = hdComments.IssueID
    WHERE (hdComments.CommentDate > hdIssues.IssueDate) AND hdComments.IsSystem = 0
    GROUP BY hdComments.IssueID
) rFirstComment ON rFirstComment.IssueID = issue.IssueID
INNER JOIN hdStatus ON hdStatus.StatusID = issue.StatusID

/*
	I pull data for my dashboard in PowerBi with this query.
	Data being pulled from Helpdesk db.
*/

select 
	/* # # # # # # # # # #   Ticket Properties   # # # # # # # # # # */
	issue.issueid as TicketID,
	(agent.firstname + ' ' + agent.lastname) as TicketAgent,
	status.name as TicketStatus,
	section.name as TicketCategoy,
	category.name as TicketSubCategory,
	case
		when convert(varchar, issue.priority) = '-1' then 'Low'
		when convert(varchar, issue.priority) = '0' then 'Normal'
		when convert(varchar, issue.priority) = '1' then 'High'
		when convert(varchar, issue.priority) = '2' then 'Critical'
	end as TicketPriority,
	issue.timespentinseconds/60 as TicketSpendedTime,
	issue.timesreopened as TicketReopenCount,
	issue.issuedate as TicketCreated,
	issue.startdate as TicketTaken,
	issue.resolveddate as TicketResolved,
	case
		when convert(varchar, issue.origin) = '0' then 'Service Desk App'
		when convert(varchar, issue.origin) = '1' then 'Email'
		when convert(varchar, issue.origin) = '3' then 'Customer Portal'
		when convert(varchar, issue.origin) = '4' then 'Scheduler'
		when convert(varchar, issue.origin) = '6' then 'Mobile App'
	end as TicketOrigin,
	value as TicketType,

	/* # # # # # # # # # #   Requester Properties   # # # # # # # # # # */
	(requester.firstname + ' ' + requester.lastname) as ReqUserName,
	case
		when convert(varchar, requester.ismanager) = '1' then 'Yes'
		when convert(varchar, requester.ismanager) = '0' then 'No'
	end as ReqIsManager,
	requester.location as ReqLocation,
	company.name as ReqCompany


from hdcustomfieldvalues

inner join hdissues issue on hdcustomfieldvalues.issueid = issue.issueid
inner join hdusers agent on issue.assignedtouserid = agent.userid
inner join hdstatus status on issue.statusid = status.statusid
inner join hdcategories category on issue.categoryid = category.categoryid
inner join hdsections section on category.sectionid = section.sectionid
inner join hdusers requester on issue.userid = requester.userid
inner join hdcompanies company on requester.companyid = company.companyid

where fieldid = 1

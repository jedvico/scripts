/*
	I pull data for my dashboard in PowerBi with this query.
	Data being pulled from Helpdesk db.
*/

select

	/* # # # # # Ticket properties # # # # # */
	hdissues.issueid as TicketID,
	(agent.firstname + ' ' + agent.lastname) as Agent,
	status.name as Status,
	section.name as MainCategory,
	category.name as SubCategory,
	case
		when convert(varchar,hdissues.priority)='-1' then 'Low'
		when convert(varchar,hdissues.priority)='0' then 'Normal'
		when convert(varchar,hdissues.priority)='1' then 'High'
		when convert(varchar,hdissues.priority)='2' then 'Critical'
	end as Priority,
	case
		when convert(varchar,hdissues.origin)='0' then 'Service Desk App'
		when convert(varchar,hdissues.origin)='1' then 'Email'
		when convert(varchar,hdissues.origin)='3' then 'Customer Portal'
		when convert(varchar,hdissues.origin)='4' then 'Scheduler'
		when convert(varchar,hdissues.origin)='6' then 'Mobile App'
	end as Origin,
	issuedate as Created,
	startdate as Taken,
	resolveddate as Resolved,
	timesreopened as ReopenCount,

	/* # # # # # Requester properties # # # # # */
	requester.username as ReqUsername,
	(requester.firstname + ' ' + requester.lastname) as ReqName,
	company.name as ReqCompany

from hdissues
	
	inner join hdusers agent on hdissues.assignedtouserid = agent.userid	
	inner join hdstatus status on hdissues.statusid = status.statusid	
	inner join hdcategories category on hdissues.categoryid = category.categoryid	
	inner join hdsections section on category.sectionid = section.sectionid	
	inner join hdusers requester on hdissues.userid = agent.userid	
	inner join hdcompanies company on requester.companyid = company.companyid

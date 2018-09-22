select 
	'Before' as "Action", *
from 
	tbl_FollowUpCall fc
	inner join tbl_FollowUp f on fc.FollowUpid = f.FUId and f.FUVal = 2
where
	not (
		isnull(CallOne,0) = 4 
		or isnull(CallTwo,0) = 4
		or isnull(CallThree,0) = 4 
		or isnull(CallFour,0) = 4)
	and isnull(CallFive, 0) = 0
	and isnull(f.LTFU,0) = 0
	and BSR_to_Follow_Up = 1

update 
	tbl_FollowUpCall
set callone=
		case when isnull(CallOne,0) = 0 then 4
		else CallOne
		end,	
	calltwo=
		case when isnull(CallOne,0) <> 0 and isnull(CallTwo,0) = 0 then 4
		else CallTwo
		end,	
	callthree= 
		case when isnull(CallOne,0) <> 0 and isnull(CallTwo,0) <> 0 and isnull(CallThree,0) = 0 then	4
		else CallThree
		end,
	callfour=
		case when isnull(CallOne,0) <> 0 and isnull(CallTwo,0) <> 0 and isnull(CallThree,0) <> 0 and isnull(CallFour,0) = 0 then 4
		else CallFour
		end,
	CallFive=
		case when isnull(CallOne,0) <> 0 and isnull(CallTwo,0) <> 0 and isnull(CallThree,0) <> 0 and isnull(CallFour,0) <> 0 and CallFive = 0 then	4
		else CallFive
		end
from 
	tbl_FollowUpCall fc
	inner join tbl_FollowUp f on fc.FollowUpid = f.FUId and f.FUVal = 2
where
	not (
		isnull(CallOne,0) = 4 
		or isnull(CallTwo,0) = 4
		or isnull(CallThree,0) = 4 
		or isnull(CallFour,0) = 4)
	and isnull(CallFive, 0) = 0
	and isnull(f.LTFU,0) = 0
	and BSR_to_Follow_Up = 1

select 
	'After' as "Action",
	*
from 
	tbl_FollowUpCall fc
	inner join tbl_FollowUp f on fc.FollowUpid = f.FUId and f.FUVal = 2
where
	(
		isnull(CallOne,0) = 4 
		or isnull(CallTwo,0) = 4
		or isnull(CallThree,0) = 4 
		or isnull(CallFour,0) = 4
	)
	and isnull(CallFive, 0) = 0
	and isnull(f.LTFU,0) = 0
	and BSR_to_Follow_Up = 1
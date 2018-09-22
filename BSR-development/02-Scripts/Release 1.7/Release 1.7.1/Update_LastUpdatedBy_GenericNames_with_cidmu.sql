/* Update following lastupdatedby names to cidmu */
Update tbl_FollowUp
set LastUpdatedBy ='cidmu'
where LastUpdatedBy in ('REQ000000952092','REQ000000955940', 'REQ000000953676','DataExtractProc_3')
or LastUpdatedBy like '%bulk%'


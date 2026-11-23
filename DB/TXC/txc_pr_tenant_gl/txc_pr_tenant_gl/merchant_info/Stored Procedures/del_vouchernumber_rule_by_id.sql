-- =============================================  
-- Author:  Ritesh Varma  
-- Create date:   
-- Description:   
-- =============================================  
CREATE PROCEDURE [merchant_info].[del_vouchernumber_rule_by_id]   
 -- Add the parameters for the stored procedure here  
 @id int = 0,   
 @deleted_by varchar(200)   
AS  
BEGIN  
    
 Update merchant_info.tb_vnr_voucher_number_rule set is_deleted=1,deleted_by=@deleted_by,deleted_on=GETUTCDATE()  
 where id=@id and Isnull(is_deleted,0) <> 1 ;  
END
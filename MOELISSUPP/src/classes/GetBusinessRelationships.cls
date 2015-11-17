//Generated by wsdl2apex

public class GetBusinessRelationships 
{
    public static testMethod void TestHarness()
    {
    	CapitalIQSetup_Controller.InitOrgInfo();
    	GetBusinessRelationshipsSoap service = new GetBusinessRelationshipsSoap();
    	BusinessRelationship[] itsGoodToBeNull = GetSuppliers(21835, null);
    	GetBusinessRelationships_element a = new GetBusinessRelationships_element();
    	ArrayOfInt b = new ArrayOfInt();
    	BusinessRelationship c = new BusinessRelationship();
    	GetBusinessRelationshipsResponse_element d = new GetBusinessRelationshipsResponse_element();
    	ArrayOfBusinessRelationship e = new ArrayOfBusinessRelationship();
    }
    
    public static BusinessRelationship[] GetSuppliers(Integer CompanyId, String ASPNetSessionId)
    {
    	GetBusinessRelationships.ArrayOfInt cid = new GetBusinessRelationships.ArrayOfInt();
    	cid.int_x = new Integer[1];
    	cid.int_x[0] = CompanyId;
    	
    	GetBusinessRelationships.ArrayOfInt types = new GetBusinessRelationships.ArrayOfInt();
    	types.int_x = new Integer[7];
    	types.int_x[0] = 15;
    	types.int_x[1] = 17;
    	types.int_x[2] = 19;
    	types.int_x[3] = 21;
    	types.int_x[4] = 23;
    	types.int_x[5] = 25;
    	types.int_x[6] = 27;
    	
    	try
    	{
	        GetBusinessRelationshipsSoap service = new GetBusinessRelationshipsSoap();
	                
	        service.inputHttpHeaders_x = new Map<String,String>();
	        service.inputHttpHeaders_x.put('Cookie', ASPNETSessionId);
	    	
	    	GetBusinessRelationships.ArrayOfBusinessRelationship results = service.GetBusinessRelationships(cid, types, false, false, false);
	    	
	        if(results != null && results.BusinessRelationship != null && results.BusinessRelationship.size() != 0)
	        {
	            return results.BusinessRelationship;    
	        }
    	}
    	catch(Exception e)
    	{
    		System.debug('@@@ GetBusinessRelationships.GetSuppliers() threw: ' + e);
    	}
    
    	return null;
    }
    
    public class GetBusinessRelationshipsSoap 
    {
    	public GetBusinessRelationshipsSoap()
        {
            CapitalIQOrganization__c myOrg = [Select org.Username__c, org.Password__c, org.WebServiceUrl__c
                    From CapitalIQOrganization__c org LIMIT 1];
            endpoint_x =  myOrg.WebServiceUrl__c + '/ciqdotnet/api/1.0/getbusinessrelationships.asmx';
        }
        public String endpoint_x;
        public Map<String,String> inputHttpHeaders_x;
        public Map<String,String> outputHttpHeaders_x;
        public String clientCert_x;
        public String clientCertPasswd_x;
        public Integer timeout_x;
        private String[] ns_map_type_info = new String[]{'http://www.capitaliq.com/CIQDotNet/api/1.0/GetBusinessRelationships', 'GetBusinessRelationships'};
        public GetBusinessRelationships.ArrayOfBusinessRelationship GetBusinessRelationships(GetBusinessRelationships.ArrayOfInt CompanyId,GetBusinessRelationships.ArrayOfInt BusinessRelationshipTypeId,Boolean IncludeSubsidiariesFlag,Boolean IncludeInvestmentsFlag,Boolean IncludePriorFlag) {
            GetBusinessRelationships.GetBusinessRelationships_element request_x = new GetBusinessRelationships.GetBusinessRelationships_element();
            GetBusinessRelationships.GetBusinessRelationshipsResponse_element response_x;
            request_x.CompanyId = CompanyId;
            request_x.BusinessRelationshipTypeId = BusinessRelationshipTypeId;
            request_x.IncludeSubsidiariesFlag = IncludeSubsidiariesFlag;
            request_x.IncludeInvestmentsFlag = IncludeInvestmentsFlag;
            request_x.IncludePriorFlag = IncludePriorFlag;
            Map<String, GetBusinessRelationships.GetBusinessRelationshipsResponse_element> response_map_x = new Map<String, GetBusinessRelationships.GetBusinessRelationshipsResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              'http://www.capitaliq.com/CIQDotNet/api/1.0/GetBusinessRelationships/GetBusinessRelationships',
              'http://www.capitaliq.com/CIQDotNet/api/1.0/GetBusinessRelationships',
              'GetBusinessRelationships',
              'http://www.capitaliq.com/CIQDotNet/api/1.0/GetBusinessRelationships',
              'GetBusinessRelationshipsResponse',
              'GetBusinessRelationships.GetBusinessRelationshipsResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.GetBusinessRelationshipsResult;
        }
    }
    public class GetBusinessRelationships_element {
        public GetBusinessRelationships.ArrayOfInt CompanyId;
        public GetBusinessRelationships.ArrayOfInt BusinessRelationshipTypeId;
        public Boolean IncludeSubsidiariesFlag;
        public Boolean IncludeInvestmentsFlag;
        public Boolean IncludePriorFlag;
        private String[] CompanyId_type_info = new String[]{'CompanyId','http://www.capitaliq.com/CIQDotNet/api/1.0/GetBusinessRelationships','ArrayOfInt','0','1','false'};
        private String[] BusinessRelationshipTypeId_type_info = new String[]{'BusinessRelationshipTypeId','http://www.capitaliq.com/CIQDotNet/api/1.0/GetBusinessRelationships','ArrayOfInt','0','1','false'};
        private String[] IncludeSubsidiariesFlag_type_info = new String[]{'IncludeSubsidiariesFlag','http://www.w3.org/2001/XMLSchema','boolean','1','1','false'};
        private String[] IncludeInvestmentsFlag_type_info = new String[]{'IncludeInvestmentsFlag','http://www.w3.org/2001/XMLSchema','boolean','1','1','false'};
        private String[] IncludePriorFlag_type_info = new String[]{'IncludePriorFlag','http://www.w3.org/2001/XMLSchema','boolean','1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.capitaliq.com/CIQDotNet/api/1.0/GetBusinessRelationships','true','false'};
        private String[] field_order_type_info = new String[]{'CompanyId','BusinessRelationshipTypeId','IncludeSubsidiariesFlag','IncludeInvestmentsFlag','IncludePriorFlag'};
    }
    public class ArrayOfInt {
        public Integer[] int_x;
        private String[] int_x_type_info = new String[]{'int','http://www.w3.org/2001/XMLSchema','int','0','-1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.capitaliq.com/CIQDotNet/api/1.0/GetBusinessRelationships','true','false'};
        private String[] field_order_type_info = new String[]{'int_x'};
    }
    public class BusinessRelationship {
        public Integer InputCompanyId;
        public String InputCompanyName;
        public Integer CompanyId1;
        public String CompanyName1 {get; set;}
        public Integer CompanyId2;
        public String CompanyName2 {get; set;}
        public Integer BusinessRelationshipTypeId;
        public String BusinessRelationshipTypeName {get; set;}
        public Boolean PriorFlag;
        public Integer BusinessRelationshipSourceTypeId;
        public String BusinessRelationshipSourceTypeName {get; set;}
        public String SimpleIndustryId;
        public String SimpleIndustryName {get; set;}
        public String SectorId;
        public String SectorName {get; set;}
        public String IndustryGroupId;
        public String IndustryGroupName;
        public String IndustryId;
        public String IndustryName;
        public String SubIndustryId;
        public String SubIndustryName;
        private String[] InputCompanyId_type_info = new String[]{'InputCompanyId','http://www.w3.org/2001/XMLSchema','int','1','1','false'};
        private String[] InputCompanyName_type_info = new String[]{'InputCompanyName','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] CompanyId1_type_info = new String[]{'CompanyId1','http://www.w3.org/2001/XMLSchema','int','1','1','false'};
        private String[] CompanyName1_type_info = new String[]{'CompanyName1','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] CompanyId2_type_info = new String[]{'CompanyId2','http://www.w3.org/2001/XMLSchema','int','1','1','false'};
        private String[] CompanyName2_type_info = new String[]{'CompanyName2','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] BusinessRelationshipTypeId_type_info = new String[]{'BusinessRelationshipTypeId','http://www.w3.org/2001/XMLSchema','int','1','1','false'};
        private String[] BusinessRelationshipTypeName_type_info = new String[]{'BusinessRelationshipTypeName','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] PriorFlag_type_info = new String[]{'PriorFlag','http://www.w3.org/2001/XMLSchema','boolean','1','1','false'};
        private String[] BusinessRelationshipSourceTypeId_type_info = new String[]{'BusinessRelationshipSourceTypeId','http://www.w3.org/2001/XMLSchema','int','1','1','false'};
        private String[] BusinessRelationshipSourceTypeName_type_info = new String[]{'BusinessRelationshipSourceTypeName','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] SimpleIndustryId_type_info = new String[]{'SimpleIndustryId','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] SimpleIndustryName_type_info = new String[]{'SimpleIndustryName','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] SectorId_type_info = new String[]{'SectorId','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] SectorName_type_info = new String[]{'SectorName','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] IndustryGroupId_type_info = new String[]{'IndustryGroupId','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] IndustryGroupName_type_info = new String[]{'IndustryGroupName','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] IndustryId_type_info = new String[]{'IndustryId','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] IndustryName_type_info = new String[]{'IndustryName','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] SubIndustryId_type_info = new String[]{'SubIndustryId','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] SubIndustryName_type_info = new String[]{'SubIndustryName','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.capitaliq.com/CIQDotNet/api/1.0/GetBusinessRelationships','true','false'};
        private String[] field_order_type_info = new String[]{'InputCompanyId','InputCompanyName','CompanyId1','CompanyName1','CompanyId2','CompanyName2','BusinessRelationshipTypeId','BusinessRelationshipTypeName','PriorFlag','BusinessRelationshipSourceTypeId','BusinessRelationshipSourceTypeName','SimpleIndustryId','SimpleIndustryName','SectorId','SectorName','IndustryGroupId','IndustryGroupName','IndustryId','IndustryName','SubIndustryId','SubIndustryName'};
    }
    public class GetBusinessRelationshipsResponse_element {
        public GetBusinessRelationships.ArrayOfBusinessRelationship GetBusinessRelationshipsResult;
        private String[] GetBusinessRelationshipsResult_type_info = new String[]{'GetBusinessRelationshipsResult','http://www.capitaliq.com/CIQDotNet/api/1.0/GetBusinessRelationships','ArrayOfBusinessRelationship','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.capitaliq.com/CIQDotNet/api/1.0/GetBusinessRelationships','true','false'};
        private String[] field_order_type_info = new String[]{'GetBusinessRelationshipsResult'};
    }
    public class ArrayOfBusinessRelationship {
        public GetBusinessRelationships.BusinessRelationship[] BusinessRelationship;
        private String[] BusinessRelationship_type_info = new String[]{'BusinessRelationship','http://www.capitaliq.com/CIQDotNet/api/1.0/GetBusinessRelationships','BusinessRelationship','0','-1','true'};
        private String[] apex_schema_type_info = new String[]{'http://www.capitaliq.com/CIQDotNet/api/1.0/GetBusinessRelationships','true','false'};
        private String[] field_order_type_info = new String[]{'BusinessRelationship'};
    }
}
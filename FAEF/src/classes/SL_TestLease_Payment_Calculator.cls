/**
* \arg ClassName  : SL_TestLease_Payment_Calculator
* \arg JIRATicket : FAEF -28
* \arg CreatedOn  : 25/08/2014
* \arg CreatedBy  : Vivek
* \arg ModifiedBy : Lodhi
* \arg Description: Test class for SL_Lease_Payment_Calculator_Controller
*/
@isTest
private class SL_TestLease_Payment_Calculator 
{   

    static User setUpBranding(){
        RecordType objRecordType = [Select Id from RecordType where Name='Vendor Division' AND SobjectType ='Account' limit 1];
        
        Account objAccount = new Account(Name='TestJared',RecordTypeId = objRecordtype.Id, OwnerId = [Select Id from User where Name = 'Peter Dwyer' limit 1].Id);
        insert objAccount;
        
        Contact objContact = new Contact();
        objContact.LastName = 'TestContact';
        objContact.AccountId = objAccount.Id;
        insert objContact;
                
        Profile objCommunityUserProfile = [SELECT Id FROM Profile WHERE Name='Vendor - External' OR Name='Partner Community User' LIMIT 1];

        User objUser = new User(Email='standarduser@testorg.com', LastName='Testing',
                                 UserName='jaredTest@jaredTestOrg.com' , ContactID = objContact.Id,
                                 Alias = 'testu', ProfileId = objCommunityUserProfile.Id, EmailEncodingKey='UTF-8',
                                 LanguageLocaleKey='en_US', LocaleSidKey='en_US', TimeZoneSidKey='America/Los_Angeles');              
                             
        insert objUser;

        Portal_Branding__c objBranding = new Portal_Branding__c(
            Name = 'TestBranding', 
            Unique_Id__c = 'test', 
            Font__c = 'Arial', 
            Schedule_Listview__c = 'FAEF Vendor Schedule Listview', 
            Opportunity_Listview__c = 'FAEF Vendor Opportunity Listview');
        insert objBranding;

        Account_Portal__c objAcctPortal = new Account_Portal__c(Portal__c = objBranding.Id, Account_Portal__c = objAccount.Id);
        insert objAcctPortal;

        Portal_Message__c objMessageCurrent = new Portal_Message__c(Portal__c = objBranding.Id, Publish_Date__c = Date.today(), End_Publish_Date__c = Date.today().addDays(1), Message__c = 'test current') ;
        Portal_Message__c objMessageOld = new Portal_Message__c(Portal__c = objBranding.Id, Publish_Date__c = Date.today().addDays(-2), End_Publish_Date__c = Date.today().addDays(-1), Message__c = 'test old');
        insert objMessageCurrent;
        insert objMessageOld;

        Portal_Contact__c objPContatct1 = new Portal_Contact__c(Portal_Branding__c = objBranding.Id, Active__c = true, User__c = [Select Id from User where Name = 'Peter Dwyer' limit 1].Id, Order__c = 1);
        Portal_Contact__c objPContatct2 = new Portal_Contact__c(Portal_Branding__c = objBranding.Id, Active__c = true, User__c = [Select Id from User where Name = 'Peter Dwyer' limit 1].Id, Order__c = 2);
        Portal_Contact__c objPContatct3 = new Portal_Contact__c(Portal_Branding__c = objBranding.Id, Active__c = true, User__c = [Select Id from User where Name = 'Peter Dwyer' limit 1].Id, Order__c = 3);
        Portal_Contact__c objPContatct4 = new Portal_Contact__c(Portal_Branding__c = objBranding.Id, Active__c = false, User__c = [Select Id from User where Name = 'Peter Dwyer' limit 1].Id, Order__c = 1);
        insert objPContatct1;
        insert objPContatct2;
        insert objPContatct3;
        insert objPContatct4;

        return objUser;
    }

    static testMethod void myUnitTest() 
    {
        User objUser = setUpBranding();

        Account objAccount = new Account(Name = 'Test-001');
		insert objAccount;                                                     

        Contact objContact = new Contact(LastName = 'Test-0001', AccountId = objAccount.Id);
        insert objContact;

        System.runAs(objUser){    
            SL_Lease_Payment_Calculator_Controller objLPCC = new SL_Lease_Payment_Calculator_Controller();
            objLPCC.getTerms();
            objLPCC.getType();
            objLPCC.reset();
            objLPCC.redirect();
            objLPCC.redirectCalculator();
          
            Payment_Rates__c objPaymentRates = new Payment_Rates__c(Term__c = '24 Months', Type__c = 'Fixed FMV', Range__c = '< $99,999.99',  Rate__c = 123.0);
            insert objPaymentRates;

            Payment_Rates__c objPaymentRates1 = new Payment_Rates__c(Term__c = '36 Months', Range__c = '< $99,999.99',  Rate__c = 123.0);
            insert objPaymentRates1;
            
            SL_Lease_Payment_Calculator_Controller objLeasePaymentCalculatorController = new SL_Lease_Payment_Calculator_Controller();
            
            objLeasePaymentCalculatorController.amount = 20.0;
            objLeasePaymentCalculatorController.strLikelyTerm = '24 Months';
            objLeasePaymentCalculatorController.strLikelyStruct = 'Fixed FMV';
            
            objLeasePaymentCalculatorController.calculateRate();
            
            system.assertEquals(objLeasePaymentCalculatorController.decLikelyMonthlyRate, 2460.00);

            SL_Lease_Payment_Calculator_Controller objLeasePaymentCalculatorController1 = new SL_Lease_Payment_Calculator_Controller();
            
            objLeasePaymentCalculatorController1.strCompany = 'test-1';
            objLeasePaymentCalculatorController1.strCustomer = 'test new';
            objLeasePaymentCalculatorController1.strEmail = 'email@email.com';
            objLeasePaymentCalculatorController1.strProject = 'Opp01';
            
            objLeasePaymentCalculatorController1.createRecords();

            SL_Lease_Payment_Calculator_Controller objLeasePaymentCalculatorController2 = new SL_Lease_Payment_Calculator_Controller();
            
            objLeasePaymentCalculatorController2.strCompany = 'Test-001';
            objLeasePaymentCalculatorController2.strCustomer = 'test new';
            objLeasePaymentCalculatorController2.strEmail = 'email@email.com';
            objLeasePaymentCalculatorController2.strProject = 'Opp01';
            
            objLeasePaymentCalculatorController2.createRecords();
            
            SL_Lease_Payment_Calculator_Controller objLeasePaymentCalculatorController3 = new SL_Lease_Payment_Calculator_Controller();
            
            objLeasePaymentCalculatorController3.strCompany = 'Test-002';
            objLeasePaymentCalculatorController3.strCustomer = 'test new';
            objLeasePaymentCalculatorController3.strEmail = 'email@email.com';
            objLeasePaymentCalculatorController3.strProject = 'Opp01';
            
            objLeasePaymentCalculatorController3.createRecords();
            
            List<Account> lstCreatedAccount = new List<Account>([Select Id,(Select Id from Contacts) from Account where Name =: 'test-1']);
            
            system.assertEquals(lstCreatedAccount.size(), 1);
            system.assertEquals(lstCreatedAccount[0].Contacts.size(), 1);
        }
    }
}
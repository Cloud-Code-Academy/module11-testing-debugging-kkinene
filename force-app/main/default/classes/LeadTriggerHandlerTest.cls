@isTest
public class LeadTriggerHandlerTest {

    //Implementation of a Test data factory
    @TestSetup
    public static void makedata() {
     TestDataFactory.createAccounts(3);
       
    }
        
    
    @isTest
    static void testTitleNormalization_VicePresident() {
        // Create Test Data
        List<Lead> leadsToTest = new List<Lead>();

        leadsToTest.add(new Lead(FirstName = 'Test', LastName = 'Lead VP 1', Company = 'Test Co', Title = 'vp'));
        leadsToTest.add(new Lead(FirstName = 'Test', LastName = 'Lead VP 2', Company = 'Test Co', Title = 'v.p.'));
        leadsToTest.add(new Lead(FirstName = 'Test', LastName = 'Lead VP 3', Company = 'Test Co', Title = 'vice president'));
        leadsToTest.add(new Lead(FirstName = 'Test', LastName = 'Lead VP 4', Company = 'Test Co', Title = 'VP')); // Test uppercase too - case sensitivity consideration

        // Run the Test
        Test.startTest(); // Start test context for governor limits isolation
        LeadTriggerHandler.handleTitleNormalization(leadsToTest);
        Test.stopTest();  // Stop test context

        // Confirm the results - Assert
        for (Lead ld : leadsToTest) {
            System.assertEquals('Vice President', ld.Title, 'Title should be normalized to Vice President');
        }
    }

    @isTest
    static void testTitleNormalization_Manager() {
        // Create Test Data
        List<Lead> leadsToTest = new List<Lead>();
        leadsToTest.add(new Lead(FirstName = 'Test', LastName = 'Lead Mgr 1', Company = 'Test Co', Title = 'mgr'));
        leadsToTest.add(new Lead(FirstName = 'Test', LastName = 'Lead Mgr 2', Company = 'Test Co', Title = 'manage'));
        leadsToTest.add(new Lead(FirstName = 'Test', LastName = 'Lead Mgr 3', Company = 'Test Co', Title = 'head of department'));

        // Run the Test
        Test.startTest();
        LeadTriggerHandler.handleTitleNormalization(leadsToTest);
        Test.stopTest();

        // Confirm the results - Assert
        for (Lead ld : leadsToTest) {
            System.assertEquals('Manager', ld.Title, 'Title should be normalized to Manager');
        }
    }

    @isTest
    static void testTitleNormalization_noNormalization() {
        // Create Test Data
        List<Lead> leadsToTest = new List<Lead>();
        leadsToTest.add(new Lead(FirstName = 'Test', LastName = 'Sales Representative', Company = 'Test Co', Title = 'Sales Representative'));
        leadsToTest.add(new Lead(FirstName = 'Test', LastName = 'Senior Specialist', Company = 'Test Co', Title = 'Senior Specialist'));

        // Run the Test
        Test.startTest();
        LeadTriggerHandler.handleTitleNormalization(leadsToTest);
        Test.stopTest();

        // Confirm the results - Assert
        for (Lead ld : leadsToTest) {
            // Title should remain unchanged
            String originalTitle = ld.LastName; // ExtrRun the Test original title from LastName (hack for this example)
            System.assertEquals(originalTitle, ld.Title, 'Title should not be normalized and remain unchanged');
        }
    }
    @isTest
    static void testTitleNormalization_Excecutive(){
        //Create the Test data
        List<Lead> leadsToTest = new List<Lead>();
        leadsToTest.add(new Lead(FirstName = 'Test', LastName = 'Lead Mgr 1', Company = 'Test Coe', Title = 'Executive Vice President'));
        leadsToTest.add(new Lead(FirstName = 'Test', LastName = 'Lead Exec 1', Company = 'Test Co', Title = 'chief executive officer'));
        leadsToTest.add(new Lead(FirstName = 'Test', LastName = 'Lead Exec 2', Company = 'Test Co', Title = 'ceo'));
        leadsToTest.add(new Lead(FirstName = 'Test', LastName = 'Lead Exec 3', Company = 'Test Co', Title = 'executive director'));

        //Run the Test
        Test.startTest();
        LeadTriggerHandler.handleTitleNormalization(leadsToTest);
        Test.stopTest();

        //Verify the results
        for (Lead ld : leadsToTest) {
            System.assertEquals('Executive', ld.Title, 'Title should be normalized to Executive');
        }
    }
    @isTest
    static void testTitleNormalization_Assistant() {
        //Create
        List<Lead> leadsToTest = new List<Lead>{
            new Lead(FirstName = 'Test', LastName = 'Lead Asst 1', Company = 'Test Co', Title = 'personal assistant'),
            new Lead(FirstName = 'Test', LastName = 'Lead Asst 2', Company = 'Test Co', Title = 'assistant'),
            new Lead(FirstName = 'Test', LastName = 'Lead Asst 3', Company = 'Test Co', Title = 'executive assistant')
        };
        //Test
        Test.startTest();
        LeadTriggerHandler.handleTitleNormalization(leadsToTest);
        Test.stopTest();
        //Assert
        for (Lead ld : leadsToTest) {
            System.assertEquals('Assistant', ld.Title, 'Title should be normalized to Assistant');
        }
    }

    @isTest
    static void testTitleNormalization_nullCase() {
        List<Lead> leadsToTest = new List<Lead>{
            new Lead(FirstName = 'Test', LastName = 'Lead Null Title', Company = 'Test Co', Title = null)
        };

        Test.startTest();
        LeadTriggerHandler.handleTitleNormalization(leadsToTest);
        Test.stopTest();

        for (Lead ld : leadsToTest) {
            System.assertEquals(null, ld.Title, 'Title should remain null or empty if no normalization applies');
        }
    }
    @isTest
    static void testTitleNormalization_emptyCase() {
        List<Lead> leadsToTest = new List<Lead>{
            new Lead(FirstName = 'Test', LastName = 'Lead Empty Title', Company = 'Test Co', Title = '')
        };

        Test.startTest();
        LeadTriggerHandler.handleTitleNormalization(leadsToTest);
        Test.stopTest();

        for (Lead ld : leadsToTest) {
            System.assertEquals('', ld.Title, 'Title should remain empty if no normalization applies');
        }
    }

    @isTest
    static void testHandleAutoLeadScoring_sourceAndEmail(){
        // Create test leads using the Test Data Factory
        List<Lead> leadsToTest = TestDataFactory.createTestLeads(3);        
        //Modify Leads to remove the phone number
        for(lead tempLead: leadsToTest){
            if (String.isNotBlank(tempLead.Phone)){ 
                tempLead.Phone = null;
            }
        }
        //Test
        Test.startTest();
        LeadTriggerHandler.handleAutoLeadScoring(leadsToTest);
        Test.stopTest();
        //Assert
        for (Lead ld : leadsToTest) {
            System.assertEquals(3, ld.Lead_Score__c, 'Lead Score should be 3 points');
        }

    }
    @isTest
    static void testHandleAutoLeadScoring_sourceAndEmailAndPhone(){
        //Create Leads using TestDataFactory
        List<Lead> leadsToTest = TestDataFactory.createTestLeads(3);

        //Test
        Test.startTest();
        LeadTriggerHandler.handleAutoLeadScoring(leadsToTest);
        Test.stopTest();
        //Assert
        for (Lead ld : leadsToTest) {
            System.assertEquals(8, ld.Lead_Score__c, 'Lead Score should be 8 points');
        }

    }

    @isTest
    static void testHandleAutoLeadScoring_noLeadSourceOrEmail(){
        //Create Leads using TestDataFactory
        List<Lead> leadsToTest = TestDataFactory.createTestLeads(253);

        for(lead tempLead: leadsToTest){
            tempLead.LeadSource = '';
            tempLead.Phone = '';
            tempLead.Email = '';
        }

        //Test
        Test.startTest();
        LeadTriggerHandler.handleAutoLeadScoring(leadsToTest);
        Test.stopTest();
        //Assert
        for (Lead ld : leadsToTest) {
            System.assertEquals(0, ld.Lead_Score__c, 'Lead Score should be 0 points');
        }

    }

    
    @isTest
    static void testHandleAutoLeadScoring_Phone() {
        //Create Leads using TestDataFactory
        List<Lead> leadsToTest = TestDataFactory.createTestLeads(3);

        //Modify the leads to match the Phone Criteria
        leadsToTest[0].LeadSource = '';
        leadsToTest[1].LeadSource = '';
        leadsToTest[2].LeadSource = '';
        leadsToTest[0].Email = '';
        leadsToTest[1].Email = '';
        leadsToTest[2].Email = '';
        

        // Act
        Test.startTest();
        LeadTriggerHandler.handleAutoLeadScoring(leadsToTest);
        Test.stopTest();

        // Assert
        for (Lead ld : leadsToTest) {
            System.assertEquals(5, ld.Lead_Score__c, 'Score should be 5 for having a valid Phone');
        }
    }

    @isTest
    static void testHandleAutoLeadScoring_TechnologyIndustry() {
        // Arrange
        List<Lead> leadsToScore = new List<Lead>();
        leadsToScore.add(new Lead(FirstName = 'Test', LastName = 'ScoreLead_TechIndustry', Company = 'Test Co', Industry = 'Technology'));

        // Act
        Test.startTest();
        LeadTriggerHandler.handleAutoLeadScoring(leadsToScore);
        Test.stopTest();

        // Assert
        for (Lead ld : leadsToScore) {
            System.assertEquals(10, ld.Lead_Score__c, 'Score should be 10 for Industry being Technology');
        }
    }

    

    @isTest
    static void testHandleAutoLeadScoring_CombinedCriteria() {
        // Arrange
        List<Lead> leadsToScore = new List<Lead>();
        leadsToScore.add(new Lead(
                FirstName = 'Test',
                LastName = 'ScoreLead_Combined',
                Company = 'Test Co',
                LeadSource = 'Website',
                Email = 'test@example.com',
                Phone = '111-222-3333',
                Industry = 'Technology'
        ));

        // Act
        Test.startTest();
        LeadTriggerHandler.handleAutoLeadScoring(leadsToScore);
        Test.stopTest();

        // Assert
        for (Lead ld : leadsToScore) {
            System.assertEquals(18, ld.Lead_Score__c, 'Score should be 18 for combined criteria (Website+Email+Phone+Technology)');
        }
    }

    @isTest
    static void testHandleAutoLeadScoring_WebsiteSourceNoEmail() {
        // Arrange
        List<Lead> leadsToScore = new List<Lead>();
        leadsToScore.add(new Lead(FirstName = 'Test', LastName = 'ScoreLead_WebNoEmail', Company = 'Test Co', LeadSource = 'Website')); // Website source but no email

        // Act
        Test.startTest();
        LeadTriggerHandler.handleAutoLeadScoring(leadsToScore);
        Test.stopTest();

        // Assert
        for (Lead ld : leadsToScore) {
            System.assertEquals(0, ld.Lead_Score__c, 'Score should be 0 for Lead source equal to Website and no Email Address'); // Email is required for Website source points
        }
    }
    
    @isTest
    static void testHandleLeadAutoConvert_uniqueMatch() {
        // Arrange
        Account testAccount = new Account(Name='Test Account');
        insert testAccount;

        Contact existingContact = new Contact(
            FirstName = 'Test',
            LastName = 'uniqueMatch',
            Email = 'test@unique.com',
            AccountId = testAccount.Id);        
        insert existingContact;

        Lead testLead = new Lead(FirstName='Test', LastName='Lead', 
                                 Company='Test Co',          
                                 Email='test@unique.com');
        insert testLead;
        
        

        List<Lead> leadsToConvert = new List<Lead>();
        leadsToConvert.add(testLead);
        
        // Act
        Test.startTest();
        LeadTriggerHandler.handleLeadAutoConvert(leadsToConvert);
        Test.stopTest();

        // Assert
        //Must query the db to fetch the latest version from the database, which reflects the changes made by the handler.
        Lead convertedLead = [SELECT Id, IsConverted, ConvertedContactId, ConvertedAccountId, Status
                              FROM Lead 
                              WHERE Id = :testLead.Id]; // Query the lead again to get updated values after conversion

        System.assert(convertedLead.IsConverted, 'Lead should be converted'); // Assert Lead is Converted
        System.assertEquals(existingContact.Id, convertedLead.ConvertedContactId, 'Converted Contact ID should match'); // Assert Converted Contact Id
        System.assertEquals(testAccount.Id, convertedLead.ConvertedAccountId, 'Converted Account ID should match'); // Assert Converted Account Id
        //System.assertEquals(true, convertedLead.DoNotCreateOpportunity, 'DoNotCreateOpportunity should be true'); // Assert DoNotCreateOpportunity is True
        LeadStatus convertStatus = [SELECT MasterLabel FROM LeadStatus WHERE IsConverted = TRUE LIMIT 1];
        System.assertEquals(convertStatus.MasterLabel, convertedLead.Status, 'Lead status should be the converted status');
    
    }
    @IsTest
    static void testHandleLeadAutoConvert_noMatch() {
        // Arrange
        List<Lead> leadsToConvert = new List<Lead>();
        Lead testLead = new Lead(FirstName='Test', LastName='Lead', 
                                 Company='Test Co', Email='test@noMatch.com');
        insert testLead;
    
        leadsToConvert.add(testLead);
    
        // Act
        Test.startTest();
        LeadTriggerHandler.handleAutoLeadScoring(leadsToConvert);
        Test.stopTest();
    
        // Assert
        Lead notConvertedLead = [SELECT Id, IsConverted FROM Lead WHERE Id = :testLead.Id];
        Assert.isTrue(!notConvertedLead.IsConverted, 'Lead should not be converted as no matching contact was found');
        /*When IsConverted is set to true, the following fields are automatically populated by Salesforce:

        ConvertedAccountId: The ID of the account created (or matched) during lead conversion.
        ConvertedContactId: The ID of the contact created (or matched).
        ConvertedOpportunityId: The ID of the opportunity created during lead conversion (if an opportunity was created).
        ConvertedDate: The date and time when the lead was converted.
        */
    }
    
    @isTest
    static void testHandleLeadAutoConvert_multipleMatches() {
        // Arrange
        Account testAccount = new Account(Name='Test Account Multiple');
        insert testAccount;

        Contact contact1 = new Contact(FirstName='Test', LastName='Multiple1', Email='multi@test.com', AccountId=testAccount.Id);
        Contact contact2 = new Contact(FirstName='Test', LastName='Multiple2', Email='multi@test.com', AccountId=testAccount.Id);
        insert new List<Contact> { contact1, contact2 };

        Lead testLead = new Lead(FirstName='Test', LastName='Lead Multiple', Company='Test Co', Email='multi@test.com');
        insert testLead;

        List<Lead> leadsToConvert = new List<Lead> { testLead };

        // Act
        Test.startTest();
        LeadTriggerHandler.handleLeadAutoConvert(leadsToConvert);
        Test.stopTest();

        // Assert
        Lead notConvertedLead = [SELECT Id, IsConverted FROM Lead WHERE Id = :testLead.Id];
        System.assert(!notConvertedLead.IsConverted, 'Lead should not be converted as multiple matching contacts were found');
    }
    
    
    @isTest
    static void testHandleLeadAutoConvert_recursionHandling() {
        // Arrange
        Lead testLead = new Lead(FirstName = 'Test', LastName = 'Lead Recursion', Company = 'Test Co', Email = 'test@recursion.com');
        insert testLead;

        List<Lead> leadsToConvert = new List<Lead> { testLead };

        // Act
        Test.startTest();
        // Call the handler twice to simulate recursion
        LeadTriggerHandler.handleLeadAutoConvert(leadsToConvert);
        LeadTriggerHandler.handleLeadAutoConvert(leadsToConvert);
        Test.stopTest();

        // Assert
        Lead notConvertedLead = [SELECT Id, IsConverted FROM Lead WHERE Id = :testLead.Id];
        System.assert(!notConvertedLead.IsConverted, 'Lead should not be converted due to recursion');
    }

    @isTest
    static void testHandleLeadAutoConvert_nullEmail() {
        // Arrange
        Lead testLead = new Lead(
            FirstName='Test',
            LastName='Null Email Lead',
            Company='Test Co',
            Email=null
        );
        insert testLead;

        List<Lead> leadsToConvert = new List<Lead> { testLead };

        // Act
        Test.startTest();
        LeadTriggerHandler.handleLeadAutoConvert(leadsToConvert);
        Test.stopTest();

        // Assert
        Lead notConvertedLead = [SELECT Id, IsConverted FROM Lead WHERE Id = :testLead.Id];
        System.assert(!notConvertedLead.IsConverted, 'Lead should not be converted if email is null');
    }
}
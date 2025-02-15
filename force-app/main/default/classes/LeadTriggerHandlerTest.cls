@isTest
public class LeadTriggerHandlerTest {

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
        //Create
        List<Lead> leadsToTest = new List<Lead>{
            new Lead(Email = 'kkinene@gmail.com', LastName = 'Lead Asst 1', Company = 'Test Co', Website = 'www.linkedIn.com', LeadSource = 'Website'),
            new Lead(Email = 'kkinene@goldbelt.com', LastName = 'Lead Asst 2', Company = 'Test Co', Website = 'www.apnews.com', LeadSource = 'Website'),
            new Lead(Email = 'kkinene@cnn.com', LastName = 'Lead Asst 3', Company = 'Test Co', Website = 'www.npr.org', LeadSource = 'Website')
        };
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
    static void testHandleAutoLeadScoring_noLeadSourceOrEmail(){
        //Create
        List<Lead> leadsToTest = new List<Lead>{
            new Lead(Email = '', LastName = 'Lead Asst 1', Company = 'Test Co', Website = 'www.linkedIn.com', LeadSource = ''),
            new Lead(Email = '', LastName = 'Lead Asst 2', Company = 'Test Co', Website = 'www.apnews.com', LeadSource = 'Website'),
            new Lead(Email = 'kkinene@cnn.com', LastName = 'Lead Asst 3', Company = 'Test Co', Website = 'www.npr.org', LeadSource = '')
        };
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
        // Arrange
        List<Lead> leadsToScore = new List<Lead>();
        leadsToScore.add(new Lead(FirstName = 'Test', LastName = 'ScoreLead_Phone', Company = 'Test Co', Phone = '123-456-7890'));

        // Act
        Test.startTest();
        LeadTriggerHandler.handleAutoLeadScoring(leadsToScore);
        Test.stopTest();

        // Assert
        for (Lead ld : leadsToScore) {
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
            System.assertEquals(0, ld.Lead_Score__c, 'Score should be 0 for Website source but no Email'); // Email is required for Website source points
        }
    }


   
}
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
        List<Lead> leadsToTest = new List<Lead>{
            new Lead(FirstName = 'Test', LastName = 'Lead Asst 1', Company = 'Test Co', Title = 'personal assistant'),
            new Lead(FirstName = 'Test', LastName = 'Lead Asst 2', Company = 'Test Co', Title = 'assistant'),
            new Lead(FirstName = 'Test', LastName = 'Lead Asst 3', Company = 'Test Co', Title = 'executive assistant')
        };

        Test.startTest();
        LeadTriggerHandler.handleTitleNormalization(leadsToTest);
        Test.stopTest();

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


}
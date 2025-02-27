public with sharing class TestDataFactory {
    public static List<Account> createAccounts(Integer count) {
        List<Account> accounts = new List<Account>();
        for (Integer i = 1; i <= count; i++) {
            accounts.add(new Account(Name = 'Test Account ' + i, Industry = 'Technology'));
        }
        insert accounts;
        return accounts;
    }

    public static List<Contact> createContacts(List<Account> accounts) {
        List<Contact> contacts = new List<Contact>();
        Integer i = 1;
        for (Account acc : accounts) {
            contacts.add(new Contact(
                FirstName = 'Test',
                LastName = 'User ' + i,
                AccountId = acc.Id
            ));
            i++;
        }
        insert contacts;
        return contacts;
    }

    public static List<Opportunity> createOpportunities(List<Account> accounts, Decimal amount) {
        List<Opportunity> opportunities = new List<Opportunity>();
        Integer i = 1;
        for (Account acc : accounts) {
            opportunities.add(new Opportunity(
                Name = 'Test Opp ' + i,
                StageName = 'Prospecting',
                CloseDate = Date.today().addDays(30),
                Amount = amount,
                AccountId = acc.Id
            ));
            i++;
        }
        insert opportunities;
        return opportunities;
    }

    public static List<Lead> createTestLeads(Integer count) {
        List<Lead> leads = new List<Lead>();
        for (Integer i = 1; i <= count; i++) {
            leads.add(new Lead(
                Email = 'test' + i + '@example.com',
                LastName = 'Lead ' + i,
                Company = 'Test Co ' + i,
                Website = 'www.test' + i + '.com',
                LeadSource = 'Website',
                Phone = '678-379-71' + (30 + i) // Unique phone numbers
            ));
        }
        insert leads;
        return leads;
    }
}

@isTest
private class PluckTest
{
	private static testMethod void pluckTest()
	{
		Lead johnny = new Lead( FirstName = 'Johnny', LastName = 'Five', Company = 'Johnny Co' );

		Test.startTest();
			Object actualName = Pluck.pluck( 'FirstName', johnny );
		Test.stopTest();

		System.assertEquals( johnny.FirstName, actualName, 'The sObject Name should be plucked' );
	}	

	private static testMethod void pluckIgnoresNulls()
	{
		Lead johnny = new Lead();

		Test.startTest();
			Set<Object> actualIds = Pluck.pluck( 'Id', new List<sObject>{ johnny } );
		Test.stopTest();

		System.assert( actualIds.isEmpty(), 'null values should be ignored' );
	}

	private static testMethod void pluckBulkTest()
	{
		Lead johnny = new Lead( FirstName = 'Johnny', LastName = 'Five', Company = 'Johnny Co' );
		Lead julie  = new Lead( FirstName = 'Julie', LastName = 'Five', Company = 'Julie Co' );
		Lead jamby = new Lead( FirstName = 'Jamby', LastName = 'Five', Company = 'Jamby Co' );

		List<Lead> allLeads = new List<Lead>{ johnny, julie, jamby };

		Test.startTest();
			Set<Object> actualNames = Pluck.pluck( 'FirstName', allLeads );
		Test.stopTest();

		System.assert( actualNames.contains( johnny.FirstName ), 'The FirstNames of the sObjects should be plucked' );
		System.assert( actualNames.contains( julie.FirstName ), 'The FirstNames of the sObjects should be plucked' );
		System.assert( actualNames.contains( jamby.FirstName ), 'The FirstNames of the sObjects should be plucked' );
	}

	private static testMethod void pluckDateTest()
	{
		Date tomorrow = Date.today().addDays(1);
		Opportunity bigSale = new Opportunity( Name = 'Sell a lot', CloseDate = tomorrow, StageName = 'Qualification' );

		Test.startTest();
			Date actualDate = Pluck.pluckDate( 'CloseDate', bigSale );
		Test.stopTest();

		System.assertEquals( tomorrow, actualDate, 'The sObject Created Date should be plucked' );
	}

	private static testMethod void pluckDatesIgnoresNulls()
	{
		Lead johnny = new Lead();

		Test.startTest();
			Set<Date> actualDates = Pluck.dates( 'CreatedDate', new List<sObject>{ johnny } );
		Test.stopTest();

		System.assert( actualDates.isEmpty(), 'null values should be ignored' );
	}

	private static testMethod void pluckDatesTest()
	{
		Date tomorrow = Date.today().addDays(1);
		Date nextWeek = Date.today().addDays(7);
		Date nextMonth = Date.today().addDays(30);
		Opportunity bigSale = new Opportunity( Name = 'Sell a lot', CloseDate = tomorrow, StageName = 'Qualification' );
		Opportunity biggerSale = new Opportunity( Name = 'Sell it all', CloseDate = nextWeek, StageName = 'Qualification' );
		Opportunity biggestSale = new Opportunity( Name = 'Permanent vacation', CloseDate = nextMonth, StageName = 'Qualification' );

		List<Opportunity> allOpportunitiesList = new List<Opportunity>{ bigSale, biggerSale, biggestSale };
		Map<Id, Opportunity> allOpportunitiesMap = new Map<Id, Opportunity>{
			'00Q0000000XXXXX' => bigSale,
			'00Q0000000XXXXY' => biggerSale,
			'00Q0000000XXXXZ' => biggestSale
		};

		Test.startTest();
			Set<Date> actualDatesList = Pluck.dates( 'CloseDate', allOpportunitiesList );
			Set<Date> actualDatesMap = Pluck.dates( 'CloseDate', allOpportunitiesMap );
		Test.stopTest();

		System.assert( actualDatesList.contains( tomorrow ), 'The sObject Close Date should be plucked' );
		System.assert( actualDatesList.contains( nextWeek ), 'The sObject Close Date should be plucked' );
		System.assert( actualDatesList.contains( nextMonth ), 'The sObject Close Date should be plucked' );
		System.assert( actualDatesMap.contains( tomorrow ), 'The sObject Close Date should be plucked' );
		System.assert( actualDatesMap.contains( nextWeek ), 'The sObject Close Date should be plucked' );
		System.assert( actualDatesMap.contains( nextMonth ), 'The sObject Close Date should be plucked' );
	}

	private static testMethod void pluckDatetimeTest()
	{
		Event birthdayParty = new Event( ActivityDateTime = DateTime.now() );

		Test.startTest();
			Datetime actualDatetime = Pluck.pluckDatetime( 'ActivityDateTime', birthdayParty );
		Test.stopTest();

		System.assertEquals( birthdayParty.ActivityDateTime, actualDatetime, 'The sObject Created Date should be plucked' );
	}

	private static testMethod void pluckDatetimesIgnoresNulls()
	{
		Lead johnny = new Lead();

		Test.startTest();
			Set<Datetime> actualDatetimes = Pluck.datetimes( 'CreatedDate', new List<sObject>{ johnny } );
		Test.stopTest();

		System.assert( actualDatetimes.isEmpty(), 'null values should be ignored' );
	}

	private static testMethod void pluckDatetimesTest()
	{
		Event birthdayParty = new Event( ActivityDateTime = DateTime.now() );
		Event cookout = new Event( ActivityDateTime = DateTime.now().addDays( 1 ) );
		Event boxSocial = new Event( ActivityDateTime = DateTime.now().addDays( 2 ) );

		List<Event> allEvents = new List<Event>{ birthdayParty, cookout, boxSocial };
		Map<Id, Event> allEventsMap = new Map<Id, Event>{
			'00Q0000000XXXXU' => birthdayParty,
			'00Q0000000XXXXW' => cookout,
			'00Q0000000XXXXX' => boxSocial
		};

		Test.startTest();
			Set<Datetime> actualDatetimesList = Pluck.datetimes( 'ActivityDateTime', allEvents );
			Set<Datetime> actualDatetimesMap = Pluck.datetimes( 'ActivityDateTime', allEventsMap );
		Test.stopTest();

		System.assert( actualDatetimesList.contains( birthdayParty.ActivityDateTime ), 'The sObjects Created Date should be plucked' );
		System.assert( actualDatetimesList.contains( cookout.ActivityDateTime ), 'The sObjects Created Date should be plucked' );
		System.assert( actualDatetimesList.contains( boxSocial.ActivityDateTime ), 'The sObjects Created Date should be plucked' );
		System.assert( actualDatetimesMap.contains( birthdayParty.ActivityDateTime ), 'The sObjects Created Date should be plucked' );
		System.assert( actualDatetimesMap.contains( cookout.ActivityDateTime ), 'The sObjects Created Date should be plucked' );
		System.assert( actualDatetimesMap.contains( boxSocial.ActivityDateTime ), 'The sObjects Created Date should be plucked' );
	}

	private static testMethod void pluckDecimalTest()
	{
		Decimal tonsOfMoney = 1337.02;
		Opportunity bigSale = new Opportunity( Name = 'Sell a lot', CloseDate = Date.today(), Amount = tonsOfMoney, StageName = 'Qualification' );

		Test.startTest();
			Decimal actualDecimal = Pluck.pluckDecimal( 'Amount', bigSale );
		Test.stopTest();

		System.assertEquals( tonsOfMoney, actualDecimal, 'The sObject Amount should be plucked' );
	}

	private static testMethod void pluckDecimalsIgnoresNulls()
	{
		Opportunity bigSale = new Opportunity();

		Test.startTest();
			Set<Decimal> actualDecimals = Pluck.decimals( 'Amount', new List<sObject>{ bigSale } );
		Test.stopTest();

		System.assert( actualDecimals.isEmpty(), 'null values should be ignored' );
	}

	private static testMethod void pluckDecimalsTest()
	{
		Decimal tonsOfMoney = 1337.02;
		Decimal evenMoreMoney = 42069.96;
		Decimal notALot = 2.13;
		Opportunity bigSale = new Opportunity( Name = 'Sell a lot', CloseDate = Date.today(), Amount = tonsOfMoney, StageName = 'Qualification' );
		Opportunity biggerSale = new Opportunity( Name = 'Sell a lot', CloseDate = Date.today(), Amount = evenMoreMoney, StageName = 'Qualification' );
		Opportunity smallSale = new Opportunity( Name = 'Sell a lot', CloseDate = Date.today(), Amount = notALot, StageName = 'Qualification' );

		List<Opportunity> allOpportunities = new List<Opportunity>{ bigSale, biggerSale, smallSale };
		Map<Id, Opportunity> allOpportunitiesMap = new Map<Id, Opportunity>{
			'00Q0000000XXXXX' => bigSale,
			'00Q0000000XXXXY' => biggerSale,
			'00Q0000000XXXXZ' => smallSale
		};

		Test.startTest();
			Set<Decimal> actualDecimalsList = Pluck.decimals( 'Amount', allOpportunities );
			Set<Decimal> actualDecimalsMap = Pluck.decimals( 'Amount', allOpportunitiesMap );
		Test.stopTest();

		System.assert( actualDecimalsList.contains( tonsOfMoney ), 'The sObject Amount should be plucked' );
		System.assert( actualDecimalsList.contains( evenMoreMoney ), 'The sObject Amount should be plucked' );
		System.assert( actualDecimalsList.contains( notALot ), 'The sObject Amount should be plucked' );
		System.assert( actualDecimalsMap.contains( tonsOfMoney ), 'The sObject Amount should be plucked' );
		System.assert( actualDecimalsMap.contains( evenMoreMoney ), 'The sObject Amount should be plucked' );
		System.assert( actualDecimalsMap.contains( notALot ), 'The sObject Amount should be plucked' );
	}

	private static testMethod void pluckIntegerTest()
	{
		Integer smallFirm = 60;
		Account smallAccount = new Account( NumberOfEmployees = smallFirm );

		Test.startTest();
			Integer actualInteger = Pluck.pluckInteger( 'NumberOfEmployees', smallAccount );
		Test.stopTest();

		System.assertEquals( smallFirm, actualInteger, 'The sObject Employees should be plucked' );
	}

	private static testMethod void pluckIntegersIgnoresNulls()
	{
		Account smallAccount = new Account();

		Test.startTest();
			Set<Integer> actualIntegers = Pluck.integers( 'NumberOfEmployees', new List<sObject>{ smallAccount } );
		Test.stopTest();

		System.assert( actualIntegers.isEmpty(), 'null values should be ignored' );
	}

	private static testMethod void pluckIntegersTest()
	{
		Integer smallFirm = 75;
		Integer mediumFirm = 90;
		Integer tinyFirm = 2;
		Account smallAccount = new Account( NumberOfEmployees = smallFirm );
		Account mediumAccount = new Account( NumberOfEmployees = mediumFirm );
		Account tinyAccount = new Account( NumberOfEmployees = tinyFirm );

		List<Account> allAccounts = new List<Account>{ smallAccount, mediumAccount, tinyAccount };
		Map<Id, Account> allAccountsMap = new Map<Id, Account>{
			'00Q0000000XXXXX' => smallAccount,
			'00Q0000000XXXXY' => mediumAccount,
			'00Q0000000XXXXZ' => tinyAccount
		};

		Test.startTest();
			Set<Integer> actualIntegersList = Pluck.integers( 'NumberOfEmployees', allAccounts );
			Set<Integer> actualIntegersMap = Pluck.integers( 'NumberOfEmployees', allAccountsMap );
		Test.stopTest();

		System.assert( actualIntegersList.contains( smallFirm ), 'The sObject Employees should be plucked' );
		System.assert( actualIntegersList.contains( mediumFirm ), 'The sObject Employees should be plucked' );
		System.assert( actualIntegersList.contains( tinyFirm ), 'The sObject Employees should be plucked' );
		System.assert( actualIntegersMap.contains( smallFirm ), 'The sObject Employees should be plucked' );
		System.assert( actualIntegersMap.contains( mediumFirm ), 'The sObject Employees should be plucked' );
		System.assert( actualIntegersMap.contains( tinyFirm ), 'The sObject Employees should be plucked' );
	}

	private static testMethod void pluckIdTest()
	{
		Lead johnny = new Lead( Id = '00Q0000000XXXXX', FirstName = 'Johnny', LastName = 'Five', Company = 'Johnny Co' );

		Test.startTest();
			Id actualId = Pluck.pluckId( 'Id', johnny );
		Test.stopTest();

		System.assertEquals( johnny.Id, actualId, 'The sObject id should be plucked' );
	}

	private static testMethod void pluckIdsIgnoresNulls()
	{
		Lead johnny = new Lead();

		Test.startTest();
			Set<Id> actualIds = Pluck.ids( 'Id', new List<sObject>{ johnny } );
		Test.stopTest();

		System.assert( actualIds.isEmpty(), 'null values should be ignored' );
	}

	private static testMethod void pluckIdsTest()
	{
		Lead johnny = new Lead( Id = '00Q0000000XXXX1', FirstName = 'Johnny', LastName = 'Five', Company = 'Johnny Co' );
		Lead julie  = new Lead( Id = '00Q0000000XXXX2', FirstName = 'Julie', LastName = 'Five', Company = 'Julie Co' );
		Lead jamby = new Lead( Id = '00Q0000000XXXX3', FirstName = 'Jamby', LastName = 'Five', Company = 'Jamby Co' );

		List<Lead> allLeads = new List<Lead>{ johnny, julie, jamby };
		Map<Id, Lead> allLeadsMap = new Map<Id, Lead>{
			'00Q0000000XXXXX' => johnny,
			'00Q0000000XXXXY' => julie,
			'00Q0000000XXXXZ' => jamby
		};

		Test.startTest();
			Set<Id> actualIdsList = Pluck.ids( 'Id', allLeads );
			Set<Id> actualIdsMap = Pluck.ids( 'Id', allLeadsMap );
		Test.stopTest();

		System.assert( actualIdsList.contains( johnny.Id ), 'The Ids of the sObjects should be plucked' );
		System.assert( actualIdsList.contains( julie.Id ), 'The Ids of the sObjects should be plucked' );
		System.assert( actualIdsList.contains( jamby.Id ), 'The Ids of the sObjects should be plucked' );
		System.assert( actualIdsMap.contains( johnny.Id ), 'The Ids of the sObjects should be plucked' );
		System.assert( actualIdsMap.contains( julie.Id ), 'The Ids of the sObjects should be plucked' );
		System.assert( actualIdsMap.contains( jamby.Id ), 'The Ids of the sObjects should be plucked' );
	}

	private static testMethod void pluckIdsAssumeIdField()
	{
		Lead jamby = new Lead( Id = '00Q0000000XXXX3', FirstName = 'Jamby', LastName = 'Five', Company = 'Jamby Co' );

		List<Lead> allLeadsList = new List<Lead>{ jamby };
		Map<Id, Lead> allLeadsMap = new Map<Id, Lead>{ '00Q0000000XXXXX' => jamby };

		Test.startTest();
			Set<Id> actualIdsList = Pluck.ids( allLeadsList );
			Set<Id> actualIdsMap = Pluck.ids( allLeadsMap );
		Test.stopTest();

		System.assert( actualIdsList.contains( jamby.Id ), 'The Ids of the sObjects should be plucked from the list' );
		System.assert( actualIdsMap.contains( jamby.Id ), 'The Ids of the sObjects should be plucked from the map' );
	}
		
	private static testMethod void pluckStringTest()
	{
		Lead johnny = new Lead( FirstName = 'Johnny', LastName = 'Five', Company = 'Johnny Co' );

		Test.startTest();
			String actualName = Pluck.pluckString( 'FirstName', johnny );
		Test.stopTest();

		System.assertEquals( johnny.FirstName, actualName, 'The sObject Name should be plucked' );
	}	

	private static testMethod void pluckStringsIgnoresNulls()
	{
		Lead johnny = new Lead();

		Test.startTest();
			Set<String> actualStrings = Pluck.strings( 'FirstName', new List<sObject>{ johnny } );
		Test.stopTest();

		System.assert( actualStrings.isEmpty(), 'null values should be ignored' );
	}

	private static testMethod void pluckStringsTest()
	{
		Lead johnny = new Lead( FirstName = 'Johnny', LastName = 'Five', Company = 'Johnny Co' );
		Lead julie  = new Lead( FirstName = 'Julie', LastName = 'Five', Company = 'Julie Co' );
		Lead jamby = new Lead( FirstName = 'Jamby', LastName = 'Five', Company = 'Jamby Co' );

		List<Lead> allLeads = new List<Lead>{ johnny, julie, jamby };
		Map<Id, Lead> allLeadsMap = new Map<Id, Lead>{
			'00Q0000000XXXXX' => johnny,
			'00Q0000000XXXXY' => julie,
			'00Q0000000XXXXZ' => jamby
		};

		Test.startTest();
			Set<String> actualNamesList = Pluck.strings( 'FirstName', allLeads );
			Set<String> actualNamesMap = Pluck.strings( 'FirstName', allLeadsMap );
		Test.stopTest();

		System.assert( actualNamesList.contains( johnny.FirstName ), 'The FirstNames of the sObjects should be plucked' );
		System.assert( actualNamesList.contains( julie.FirstName ), 'The FirstNames of the sObjects should be plucked' );
		System.assert( actualNamesList.contains( jamby.FirstName ), 'The FirstNames of the sObjects should be plucked' );
		System.assert( actualNamesMap.contains( johnny.FirstName ), 'The FirstNames of the sObjects should be plucked' );
		System.assert( actualNamesMap.contains( julie.FirstName ), 'The FirstNames of the sObjects should be plucked' );
		System.assert( actualNamesMap.contains( jamby.FirstName ), 'The FirstNames of the sObjects should be plucked' );
	}
}
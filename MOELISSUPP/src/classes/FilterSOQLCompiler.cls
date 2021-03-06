/*
Created: Serg Brull
version: 1.0.2.010

Updated by Privlad
*/
public virtual with sharing class FilterSOQLCompiler {
    
    public class FilterSet {
        public String FilterType { get; set; }
        public String Field { get; set; }
        public String Operator { get; set; }
        public String Value { get; set; }
        public String ValueId { get; set; }
        public String Order { get; set; } 
        
        public String Compiled { get; set; }
    }
    
    public String sObjectName {get; set;}
    public List<FilterSet> m_filter_set = new List<FilterSet>();
    public String m_advenced;
    public String m_parse_result = null;
    public boolean isTest = false;
    
    protected String m_trace = '';
    public String trace {
        get {
            return m_trace;
        }
        set {
            m_trace += '\n' + value + ' |\n ';
        }
        
    }
    
    public String Filters  {
        set {
            parseFilter(value);
        }
    }

    public String Advenced  {
        set {
            m_advenced = value;
        }
    }
        
    public FilterSOQLCompiler() {}
    
    public FilterSOQLCompiler(String soName) {
        this.sObjectName = soName;
    }
    
    public FilterSOQLCompiler(String p_filters, String p_advenced) {
        Initialize(p_filters, p_advenced);
    }
    
    public void Initialize(String p_filters, String p_advenced) {
        m_advenced = p_advenced;
        parseFilter(p_filters);
    }
    
    public void Initialize(String p_filters, String p_advenced, String soName) {
        this.sObjectName = soName;
        m_advenced = p_advenced;
        parseFilter(p_filters);
    }
    
    public String SOQL {
        get {
            return getSOQL();
        }
        
    }
    
    protected Boolean checkingData(FilterSet filter) 
    {
        trace += 'FilterSOQLCompiler::started';

        if(filter.FilterType == 'DATE') 
        {
            try 
            {
                Date parsedDate = Date.valueOf(filter.Value);
            }
            catch(Exception e)
            {
                throw new FilterException('Date ( ' + filter.Value+ ' ) in filter creteria is incorrect.'); 
            }
        } 
        else if(filter.FilterType == 'DATETIME') 
        {
            String prepareDate = filter.Value.replace('T', ' ').replace('Z','');
            try 
            {
                Datetime parsedDatetime = Datetime.valueOf(prepareDate);
            }
            catch(Exception e)
            {
                throw new FilterException('Date and time ( ' + prepareDate + ' ) in filter creteria is incorrect.'); 
            }
        } 
        else if(filter.FilterType == 'ID') 
        {
            try 
            {
                ID parsedID = filter.Value;
            }
            catch(Exception e)
            {
                throw new FilterException('ID ( ' + filter.Value+ ' ) in filter creteria is incorrect.'); 
            }
        }
        else if(filter.FilterType == 'REFERENCE') 
        {
            String result = null;
            Boolean isException = false;
            try {
                result = getReferenceId(filter);
            } 
            catch(Exception ex) 
            {
                isException = true;
            }
            if( result== null || result == '000000000000000' || isException) 
            {
                throw new FilterException('Lookup value ( ' + filter.Value + ' ) in filter creteria is incorrect.'); 
            }
        }
        return true;
    }
    
    public String validate() 
    {
        String result = '';
        for( Integer i = 0; i < m_filter_set.size(); i++ ) 
        {
            try 
            {   
                checkingData(m_filter_set[i]);
            }
            catch(Exception fe) 
            {
                result += fe.getMessage() + '   ' ;
            }   
        }
        return result;
    }

    
    public void parseFilter(String p_filters) {
        m_filter_set = new List<FilterSet>();
        if(p_filters == null) return;
        //trace = p_filters;
        try {
            String[] filters = p_filters.split('##');
            //trace = 'parseFilter::filters size:: ' + filters.size();
            for(Integer i = 0; i < filters.size(); i++) {
                String[] field = (filters[i]).split('___');
                //trace = 'parseFilter::field size:: ' + field.size();
                Integer size = field.size();
                    if(size>= 3)
                    {
                        //trace = 'parseFilter::i:: ' + i;  
                        FilterSet filter_set = new FilterSet();
                        filter_set.FilterType = field[0].trim().toUpperCase(); 
                        filter_set.Field = field[1].trim();
                        filter_set.Operator = field[2].trim();
                        filter_set.Value = (size >= 4)? field[3]: '';
                        filter_set.Value = String.escapeSingleQuotes(filter_set.Value);
                        filter_set.Value = AddSlashesToSpecChar(filter_set.Value);
                        filter_set.ValueId = (size >= 5)? field[4]: '';
                        filter_set.Order = ''+(i+1);
                        
                        //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Filter :: ' + field));

                        /*
                        trace = 'Field: ' + filter_set.Field + '; FilterType: ' + filter_set.FilterType + 
                                '; Operator: ' + filter_set.Operator + '; Value: ' + filter_set.Value + 
                                '; Order: ' + filter_set.Order;
                        */

                        m_filter_set.add(filter_set);
                    }
            }
        }
        catch (FilterException fe)
        {
            throw fe;
        }
        catch (Exception e) {
            trace = 'parseFilter1: ' + e.getMessage();
        }
        
        //System.debug(' ============= '+m_filter_set);
    }
    
    protected virtual String getSOQL() {
        m_parse_result = remapAdvanced(m_advenced);
        //trace = 'remapAdvanced: ' + remapAdvanced(m_advenced);
        try {
            for( Integer i = 0; i < m_filter_set.size(); i++ ) {
                trace = 'getSOQL::['+ i +']::Compile...'; 
                m_filter_set[i].Compiled = compileFilter(m_filter_set[i]);
                trace = 'getSOQL::['+ i +']::Compile result: ' + m_filter_set[i].Compiled;
                m_parse_result = compileFilters(m_filter_set[i].Order, m_filter_set[i].Compiled);
            }
        }catch (Exception e) {
            trace = 'getSOQL error::' + e.getMessage();
        }
        //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'm_parse_result:: ' + m_parse_result));
        return m_parse_result;
    }
    
    protected virtual String remapAdvanced(String p_advenced) {
        return p_advenced.replaceAll('([0-9]+)', '{#$1}');
    }
    
    protected virtual String compileFilters(String p_filter_order, String p_filter_compiled) {
        //trace = 'compileFilters: ' + '{#'+ p_filter_order +'}' + '; filter: ' + p_filter_compiled;
        System.debug('+++++++++++++++++++'+m_parse_result);
        System.debug('==================compileFilters: ' + '{#'+ p_filter_order +'}' + '; filter: ' + p_filter_compiled);
        return m_parse_result.replaceAll('\\{#'+ p_filter_order +'\\}', p_filter_compiled);
    }
    
    protected virtual String compileFilter(FilterSet p_filter_set) {
        String result = '';
        String value = '';
        Boolean is_multipicklist = isMultipicklist(p_filter_set);
        Boolean is_picklist = isPicklist(p_filter_set);
        Boolean is_number = isNumber(p_filter_set);
        Boolean is_boolean = isBoolean(p_filter_set);
        Boolean is_dateORtime = isDateOrTime(p_filter_set);
        Boolean is_reference = isReference(p_filter_set);
        
        value = getFilterValue(p_filter_set);
        //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'qvalue:: ' + Q(value)));
         
        if(p_filter_set.Operator == 'equal') {
            result = p_filter_set.Field + ' = ' + value;
        } else if(p_filter_set.Operator == 'notEqual') {
            result = p_filter_set.Field + ' != ' + value;
        } else if(p_filter_set.Operator == 'lessThan') {
            result = p_filter_set.Field +  ' < ' + value;
        } else if(p_filter_set.Operator == 'greaterThan') {
            result = p_filter_set.Field + ' > ' + value;
        } else if(p_filter_set.Operator == 'lessOrEqual') {
            result = p_filter_set.Field + ' <= ' + value;
        } else if(p_filter_set.Operator == 'greaterOrEqual') {
            result = p_filter_set.Field + ' >= ' + value;
        }else if(p_filter_set.Operator == 'startsWith') {
            result = p_filter_set.Field + ' LIKE ' + Q(value+'%');
        }else if(p_filter_set.Operator == 'contains') {
            result = p_filter_set.Field +  ' LIKE ' + Q('%' + value + '%');  
        }else if(p_filter_set.Operator == 'notContain') {
            result = 'NOT('+p_filter_set.Field +  ' LIKE ' + Q('%' + value + '%')+')';
        
        }else if(p_filter_set.Operator == 'includes' && p_filter_set.Field=='recordtypeid') {
            result =  p_filter_set.Field +  ' IN ( ' + splitMultiPicklist2Includes(value) +  ' )';
        }else if(p_filter_set.Operator == 'excludes' && p_filter_set.Field=='recordtypeid') {
            result = ' NOT ( ' + p_filter_set.Field +  ' IN ( ' + splitMultiPicklist2Includes(value) +  ' ))';
        
        }else if(p_filter_set.Operator == 'includes' && !is_multipicklist && !is_picklist) {
            result =  p_filter_set.Field +  ' IN ( ' + Q(value) +  ' )';
        }else if(p_filter_set.Operator == 'excludes' && !is_multipicklist && !is_picklist) {
            result = 'NOT('+p_filter_set.Field +  ' IN ( ' + Q(value) +  ' )'+')';
        }else if(p_filter_set.Operator == 'includes' && is_picklist) {
            result =  p_filter_set.Field +  ' IN ( ' + splitMultiPicklist2Includes(value) +  ' )';
        }else if(p_filter_set.Operator == 'excludes' && is_picklist) {
            result = 'NOT('+p_filter_set.Field +  ' IN ( ' + splitMultiPicklist2Includes(value) +  ' ))';
        }else if(p_filter_set.Operator == 'includes' && is_multipicklist) {
            result =  p_filter_set.Field +  ' INCLUDES ( ' + splitMultiPicklist2Includes(value) +  ' )';
        }else if(p_filter_set.Operator == 'excludes' && is_multipicklist) {
            result = p_filter_set.Field +  ' EXCLUDES ( ' + splitMultiPicklist2Includes(value) +  ' )';
        }
        system.debug('Field!!!: ' + p_filter_set.Field + '; FilterType: ' + p_filter_set.FilterType +'!!!') ; 
        //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'result:: ' + result));
         
        return '('+result+')';
    }
    
    protected virtual String getFilterValue(FilterSet p_filter_set){
        String value = '';
        Boolean is_multipicklist = isMultipicklist(p_filter_set);
        Boolean is_picklist = isPicklist(p_filter_set);
        Boolean is_number = isNumber(p_filter_set);
        Boolean is_boolean = isBoolean(p_filter_set);
        Boolean is_dateORtime = isDateOrTime(p_filter_set);
        Boolean is_reference = isReference(p_filter_set);
        
        if (is_reference){
            
            Id v = getReferenceId(p_filter_set);
            //if (v==null) value = null; else 
            value = Q(v);
            p_filter_set.ValueId = value;
        }
        else if (p_filter_set.Field=='recordtypeid'){
            String full_value = p_filter_set.Value;
            for (String val : full_value.split(',')){
                if (val==null || val.trim().length()==0) continue;
                p_filter_set.Value = val.trim();
                Id v = getReferenceId(p_filter_set);
                value += ','+v;
            }
            if (value.length()>0) value = value.substring(1);
        }
        else
        if (isNotQuoteOperator(p_filter_set) || is_number || is_boolean || is_dateORtime) {
            value = p_filter_set.Value;
            if (value.trim().length()==0){
                value = 'null';
            }
        } else if (is_multipicklist) {
            value = splitMultiPicklist2Equal(p_filter_set.Value);
        } else {
            value = Q(p_filter_set.Value);
        }
        
        if(is_number && value == '') {
            value = '0';
        }
        
        //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'value:: ' + value));
        return value;
    }
    
    public Id getReferenceId(FilterSet p_filter_set){
        //return '001P0000001Qfcz';
        String res = null;
        if(isTest) res = null;
        trace = 'getReferenceId :: ' + p_filter_set.ValueId + '\n';
        if (p_filter_set.ValueId!='' && p_filter_set.ValueId.substring(0, 3)!='000'){
            res = p_filter_set.ValueId;
        } else {
            String so = SL_ME_DescribeObject_Core.getInstance().getFieldReferenceByName(this.SObjectName, p_filter_set.Field);
            trace = 'SOName: '+this.SObjectName;
            trace = 'SOName: '+p_filter_set.Field;
            trace = 'SOName: '+so;    
            String query = 'SELECT Id, Name FROM ' + so + ' WHERE Name=\''+p_filter_set.Value+'\' LIMIT 1';
            //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'id query:: ' + query));
            try{
                SObject rt = Database.query(query).get(0);
                res = rt.Id;
            } catch (Exception e){
                trace = 'getReferenceId :: ' + e.getMessage() + '<br/>' +query;
            }
        }
        return res;
    }
    
    protected Boolean isNotQuoteOperator(FilterSet p_filter_set) {
        return ((p_filter_set.Operator == 'includes')   || 
                (p_filter_set.Operator == 'excludes')   || 
                (p_filter_set.Operator == 'startsWith') || 
                (p_filter_set.Operator == 'contains')   ||
                (p_filter_set.Operator == 'notContain'));
    }
    
    protected Boolean isMultipicklist(FilterSet p_filter_set) {
        return (p_filter_set.FilterType == 'MULTIPICKLIST');
    }
    
    protected Boolean isPicklist(FilterSet p_filter_set) {
        return (p_filter_set.FilterType == 'PICKLIST');
    }
    
    protected Boolean isBoolean(FilterSet p_filter_set) {
        return (p_filter_set.FilterType == 'BOOLEAN');
    }
    
    protected Boolean isDateOrTime(FilterSet p_filter_set) {
        return (p_filter_set.FilterType == 'DATETIME' || 
                p_filter_set.FilterType == 'DATE' ||
                p_filter_set.FilterType == 'TIME');
    }
    
    protected Boolean isNumber(FilterSet p_filter_set) {
        return (p_filter_set.FilterType == 'DOUBLE' || 
                p_filter_set.FilterType == 'CURRENCY' ||
                p_filter_set.FilterType == 'PERCENT' ||
                p_filter_set.FilterType == 'INTEGER' );
    }
    
    protected Boolean isReference(FilterSet p_filter_set){
        return (p_filter_set.FilterType == 'REFERENCE');
    }
    
    protected String removeInvalidChars(String value) 
    {
        String result = value;
        value = value.replace('"', '');
        value = value.replace('\\', '');
        return value;
    }
    
    protected String Q(String p_str) {
        return '\'' + p_str + '\'';
    }
    
    public void toTestHelp(String inVal)
    {
        String retVal = splitMultiPicklist2Equal(inVal);
        retVal = splitMultiPicklist2Includes(inVal);
        retVal = removeInvalidChars(inVal);
        Boolean bolFlag = checkingData(m_filter_set.get(0));
        m_filter_set.get(0).FilterType = 'DATE';
        try{ bolFlag = checkingData(m_filter_set.get(0));}
        catch (Exception e){}
        m_filter_set.get(0).FilterType = 'DATETIME';
        try{ bolFlag = checkingData(m_filter_set.get(0));}
        catch (Exception e){}
        m_filter_set.get(0).FilterType = 'ID';
        try{ bolFlag = checkingData(m_filter_set.get(0));}
        catch (Exception e){}
        m_filter_set.get(0).FilterType = 'REFERENCE';
        try{ bolFlag = checkingData(m_filter_set.get(0));}
        catch (Exception e){}
        
        
    }
    
    protected String splitMultiPicklist2Equal(String p_str) {
        String retValue = '';
        if(p_str!=null && p_str!='')
        {
            String[] aSplitVal = p_str.split(',',0);
            for(string tmpVal:aSplitVal)
            {
                retValue = retValue+';'+tmpVal.trim();
            }
            if(retValue!='') retValue = retValue.substring(1);
        }
        
        
        return '\'' + retValue + '\'';
    }

    protected String splitMultiPicklist2Includes(String p_str) {
        String retValue = '';
        if(p_str!=null && p_str!='')
        {
            String[] aSplitVal = p_str.split(',',0);
            for(string tmpVal:aSplitVal)
            {
                retValue = retValue+',\''+tmpVal.trim()+'\'';
            }
            if(retValue!='') retValue = retValue.substring(1);
        }
        
        
        return retValue!=''?retValue:'\'\'';
    }

    
    protected String AddSlashesToSpecChar(String p_str)
    {
        return p_str.replaceAll('\\$', '\\\\\\$');
    }
    
    //"SearchQ": "STRING___billingcity___notEqual___test##PICKLIST___type___excludes___Analyst##REFERENCE___parentid___notEqual___001T000000M0SZ4" 
    // "SearchParam" :"1 AND 2 AND 3"
    
    class FilterException extends Exception{}   
    
    public static testmethod void doTest()
    {
        Test.startTest();
        
        FilterSOQLCompiler fSOQLComp = new FilterSOQLCompiler();
        fSOQLComp = new FilterSOQLCompiler('account');
        fSOQLComp = new FilterSOQLCompiler('STRING___billingcity___equal___test##PICKLIST___type___excludes___Analyst##REFERENCE___parentid___notEqual___001T000000M0SZ4','1 AND 2 AND 3');
        fSOQLComp = new FilterSOQLCompiler('DATETIME___billingcity___notEqual___test##MULTIPICKLIST___type___excludes___Analyst##DATE___parentid___notEqual___001T000000M0SZ4','1 AND 2 AND 3');
        fSOQLComp = new FilterSOQLCompiler('TIME___billingcity___notEqual___test##DOUBLE___type___includes___Analyst##CURRENCY___parentid___lessThan___001T000000M0SZ4','1 AND 2 AND 3');
        fSOQLComp = new FilterSOQLCompiler('PERCENT___billingcity___greaterThan___test##INTEGER___type___excludes___Analyst##CURRENCY___parentid___notEqual___001T000000M0SZ4','1 AND 2 AND 3');
        fSOQLComp = new FilterSOQLCompiler('STRING___billingcity___lessOrEqual___test','1');
        fSOQLComp = new FilterSOQLCompiler('STRING___billingcity___greaterOrEqual___test','1');
        fSOQLComp = new FilterSOQLCompiler('STRING___billingcity___startsWith___test','1');
        fSOQLComp = new FilterSOQLCompiler('STRING___billingcity___contains___test','1');
        fSOQLComp = new FilterSOQLCompiler('STRING___billingcity___notContain___test','1');
        fSOQLComp = new FilterSOQLCompiler('STRING___billingcity___includes___test','1');
        fSOQLComp = new FilterSOQLCompiler('STRING___billingcity___excludes___test','1');
        fSOQLComp.isTest = true;
        fSOQLComp.toTestHelp('val1,val2,val3');
        fSOQLComp.getReferenceId(fSOQLComp.m_filter_set.get(0));
        fSOQLComp.Initialize('STRING___billingcity___excludes___test','1','account');
        //fSOQLComp.parseFilter(null);
        String tpmStr = fSOQLComp.SOQL;
        //tpmStr = fSOQLComp.trace;     
        fSOQLComp.Filters = 'sdfg sdfg';
        fSOQLComp.Advenced = '1';
        
        Test.stopTest();
    }

}
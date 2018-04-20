public class FirstTestTriggerHandler 
{
    /**
     *   Enum representing each of before/after CRUD events on Sobjects
     */
    public enum Evt 
    {
        afterdelete, afterinsert, afterundelete,
        afterupdate, beforedelete, beforeinsert, beforeupdate   
    }

    public FirstTestTriggerHandler(){
        this.manage();
    }

    public void manage()
    {
        Evt ev = null;
        if(Trigger.isInsert && Trigger.isBefore)
        {
            ev = Evt.beforeinsert;
            this.handler(ev.name());
        }
        else if(Trigger.isInsert && Trigger.isAfter)
        {
            ev = Evt.afterinsert;
        }
        else if(Trigger.isUpdate && Trigger.isBefore)
        {
            ev = Evt.beforeupdate;
        }
        else if(Trigger.isUpdate && Trigger.isAfter)
        {
            ev = Evt.afterupdate;
        }
        else if(Trigger.isDelete && Trigger.isBefore)
        {
            ev = Evt.beforedelete;
            //this.handler(ev.name());
        }
        else if(Trigger.isDelete && Trigger.isAfter)
        {
            ev = Evt.afterdelete;
        }
        else if(Trigger.isundelete)
        {
            ev = Evt.afterundelete;             
        }
    }

    public void handler(String evtName) {
        if (evtName == 'beforeinsert') {
            System.debug('Yes it\'s: ' + evtName);
            System.debug('Call helper and do magic!');
            System.debug('Trriger ' + Trigger.new);
        } else if (evtName == 'beforedelete') {
            for (Account a : [SELECT Id, Name FROM Account WHERE Id = :Trigger.new]) {
                Trigger.oldMap.get(a.Id).addError('fffffffffffff');
            }
        } else {
            System.debug('something other');
        }
    }
}
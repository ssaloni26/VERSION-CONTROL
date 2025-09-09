import { LightningElement, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { NavigationMixin } from 'lightning/navigation';
import { createRecord, updateRecord, deleteRecord, getRecord, getRecordNotifyChange } from 'lightning/uiRecordApi';
import { refreshApex } from '@salesforce/apex';
import { loadScript, loadStyle } from 'lightning/platformResourceLoader';
import { encodeDefaultFieldValues } from 'lightning/pageReferenceUtils';

// LMS
import { publish, subscribe, unsubscribe, MessageContext } from 'lightning/messageService';
import demoMessageChannel from '@salesforce/messageChannel/SampleMessageChannel.messageChannel-meta.xml';

// Apex
import getAccounts from '@salesforce/apex/AccountController.getAccounts';

// Fields
import NAME_FIELD from '@salesforce/schema/Account.Name';

export default class All_Methods extends NavigationMixin(LightningElement) {
    recordId = '001XXXXXXXXXXXX'; // Replace with valid Id
    wiredAcc;
    subscription;

    // Wire Example
    @wire(getRecord, { recordId: '$recordId', fields: [NAME_FIELD] })
    acc(result) {
        this.wiredAcc = result;
    }

    // LMS Context
    @wire(MessageContext) messageContext;

    // ---------------- Browser ----------------
    showAlert() { window.alert('This is an alert!'); }
    showConfirm() {
        if (window.confirm('Proceed?')) {
            this.showToastMessage('Confirmed', 'You clicked OK', 'success');
        }
    }
    showPrompt() {
        const val = window.prompt('Enter a name:');
        console.log('Prompt Value:', val);
    }
    openWindow() { window.open('https://salesforce.com', '_blank'); }
    focusInput() { this.template.querySelector('.focusMe').focus(); }
    checkInput() {
        const input = this.template.querySelector('.focusMe');
        input.reportValidity();
        console.log('checkValidity:', input.checkValidity());
    }

    // ---------------- UI ----------------
    showToast() {
        this.showToastMessage('Success', 'Toast from LWC', 'success');
    }
    showToastMessage(title, msg, variant) {
        this.dispatchEvent(new ShowToastEvent({ title, message: msg, variant }));
    }
    navigateToRecord() {
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: { recordId: this.recordId, actionName: 'view' }
        });
    }

    // ---------------- LDS ----------------
    createAcc() {
        const fields = { Name: 'Demo Account' };
        createRecord({ apiName: 'Account', fields })
            .then(() => this.showToastMessage('Created', 'Account created', 'success'));
    }
    updateAcc() {
        const fields = { Id: this.recordId, Name: 'Updated Name' };
        updateRecord({ fields })
            .then(() => this.showToastMessage('Updated', 'Account updated', 'success'));
    }
    deleteAcc() {
        deleteRecord(this.recordId)
            .then(() => this.showToastMessage('Deleted', 'Account deleted', 'success'));
    }
    refreshData() {
        refreshApex(this.wiredAcc);
        getRecordNotifyChange([{ recordId: this.recordId }]);
    }

    // ---------------- Apex ----------------
    callApexImperative() {
        getAccounts({ limitSize: 5 })
            .then(data => console.log('Accounts:', data))
            .catch(error => console.error(error));
    }

    // ---------------- LMS ----------------
    publishMessage() {
        publish(this.messageContext, demoMessageChannel, { text: 'Hello from LWC' });
    }
    subscribeMessage() {
        if (!this.subscription) {
            this.subscription = subscribe(this.messageContext, demoMessageChannel, (msg) => {
                console.log('LMS Received:', msg);
            });
        }
    }
    unsubscribeMessage() {
        unsubscribe(this.subscription);
        this.subscription = null;
    }

    // ---------------- Lifecycle ----------------
    connectedCallback() {
        console.log('connectedCallback - init');
        setTimeout(() => console.log('setTimeout fired!'), 2000);
        setInterval(() => console.log('setInterval tick'), 5000);

        const defaults = encodeDefaultFieldValues({ FirstName: 'John', LastName: 'Doe' });
        console.log('Encoded Defaults:', defaults);
    }
    renderedCallback() { console.log('renderedCallback'); }
    disconnectedCallback() { console.log('disconnectedCallback'); }
    errorCallback(error, stack) { console.error('Error caught:', error, stack); }

    // ---------------- Form ----------------
    handleFormSuccess() {
        this.showToastMessage('Form Submitted', 'Account saved', 'success');
    }
}

import { LightningElement, track, wire } from 'lwc';
import { getListUi } from 'lightning/uiListApi';
import getAllSObjects from '@salesforce/apex/SObjectListController.getAllSObjects';
import getRecentlyViewedListView from '@salesforce/apex/SObjectListController.getRecentlyViewedListView';
import updateRecords from '@salesforce/apex/SObjectListController.updateRecords';
import deleteRecords from '@salesforce/apex/SObjectListController.deleteRecords';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { refreshApex } from '@salesforce/apex';

export default class DynamicObjectList extends LightningElement {
    @track objectOptions = [];
    @track selectedObject = '';
    @track selectedListView = '';
    @track columns = [];
    @track rows = [];
    @track draftValues = [];
    @track loading = false;
    @track errorMessage = '';
    @track isModalOpen = false;
    @track recordForm = {};
    @track selectedRows = [];

    wiredListViewResult;

    hideCheckbox = false;
    showRowNumbers = true;

    connectedCallback() {
        this.loadObjects();
    }

    // Load all objects dynamically
    async loadObjects() {
        this.loading = true;
        try {
            const result = await getAllSObjects();
            this.objectOptions = result.map(obj => ({ label: obj.label, value: obj.apiName }));
        } catch (err) {
            this.showToast('Error', 'Failed to load objects: ' + this.getErrorMessage(err), 'error');
        } finally {
            this.loading = false;
        }
    }

    // Handle object selection change
    async handleObjectChange(event) {
        this.selectedObject = event.detail.value;
        this.columns = [];
        this.rows = [];
        this.draftValues = [];
        this.selectedListView = '';
        this.errorMessage = '';

        if (!this.selectedObject) return;

        this.loading = true;
        try {
            const listViewApiName = await getRecentlyViewedListView({ objectApiName: this.selectedObject });
            if (!listViewApiName) {
                this.errorMessage = 'No Recently Viewed list found for this object';
                return;
            }
            this.selectedListView = listViewApiName;
        } catch (err) {
            this.errorMessage = 'Error fetching list view: ' + this.getErrorMessage(err);
        } finally {
            this.loading = false;
        }
    }

    get isReadyForWire() {
        return this.selectedObject && this.selectedListView;
    }

    // Wire list view dynamically
    @wire(getListUi, { objectApiName: '$selectedObject', listViewApiName: '$selectedListView' })
    wiredListView(result) {
        this.wiredListViewResult = result;
        const { data, error } = result;

        if (data) {
            try {
                const displayCols = data.info?.displayColumns || [];

                // Build datatable columns dynamically
                this.columns = displayCols
                    .filter(c => c.fieldApiName)
                    .map(c => ({
                        label: c.label,
                        fieldName: c.fieldApiName,
                        type: this.getColumnType(c.dataType),
                        editable: this.isColumnEditable(c)
                    }));

                // Add row actions (Edit modal + Delete)
                this.columns.push({
                    type: 'action',
                    typeAttributes: {
                        rowActions: [
                            { label: 'Edit', name: 'edit' },
                            { label: 'Delete', name: 'delete' }
                        ]
                    }
                });

                // Map rows
                this.rows = (data.records?.records || []).map(rec => {
                    const row = { Id: rec.id };
                    displayCols.forEach(c => {
                        if (!c.fieldApiName) return;
                        row[c.fieldApiName] = rec.fields?.[c.fieldApiName]?.value ?? null;
                    });
                    return row;
                });

                this.errorMessage = '';
            } catch (e) {
                console.error('Error mapping list view data:', e);
                this.rows = [];
                this.columns = [];
                this.errorMessage = 'Failed to map list view data.';
            }
        } else if (error) {
            console.error('Error loading list view:', error);
            this.rows = [];
            this.columns = [];
            this.errorMessage = 'Failed to load Recently Viewed list.';
        }
    }

    // Determine editable columns
    isColumnEditable(colInfo) {
        if (typeof colInfo.editable === 'boolean') return colInfo.editable;

        const name = (colInfo.fieldApiName || '').toLowerCase();
        const nonEditablePatterns = [
            '^id$', 'createddate', 'lastmodifieddate', 'systemmodstamp', 'createdbyid',
            'lastmodifiedbyid', 'isdeleted', 'ownerid', '^recordtypeid$', '^currencyiso$', 'latitude', 'longitude'
        ];
        if (nonEditablePatterns.some(p => new RegExp(p).test(name))) return false;

        const nonEditableTypes = ['reference', 'location', 'base64', 'textarea', 'json'];
        if (colInfo.dataType && nonEditableTypes.includes(colInfo.dataType.toLowerCase())) return false;

        return true;
    }

    // Map Salesforce field type to datatable type
    getColumnType(apiType) {
        if (!apiType) return 'text';
        switch (apiType.toLowerCase()) {
            case 'phone': return 'phone';
            case 'email': return 'email';
            case 'date':
            case 'datetime': return 'date';
            case 'currency': return 'currency';
            case 'double':
            case 'integer':
            case 'percent': return 'number';
            case 'boolean': return 'boolean';
            case 'url': return 'url';
            case 'reference': return 'text';
            default: return 'text';
        }
    }

    // Inline save handler
    async handleInlineSave(event) {
        const updatedFields = event.detail.draftValues;
        if (!updatedFields || updatedFields.length === 0) return;

        this.loading = true;
        try {
            const payload = updatedFields.map(dv => ({
                sobjectType: this.selectedObject,
                fields: { ...dv }
            }));

            await updateRecords({ updates: payload });
            this.draftValues = [];
            this.refreshList();
            this.showToast('Success', `${updatedFields.length} record(s) updated successfully`, 'success');
        } catch (err) {
            console.error(err);
            this.showToast('Error', 'Failed to update records: ' + this.getErrorMessage(err), 'error');
        } finally {
            this.loading = false;
        }
    }

    // Modal for new record
    handleNewRecord() {
        this.recordForm = { Id: null };
        this.isModalOpen = true;
    }

    handleEditRow(event) {
        const row = event.detail?.row || {};
        this.recordForm = { ...row };
        this.isModalOpen = true;
    }

    handleCloseModal() {
        this.isModalOpen = false;
    }

    handleSaveSuccess() {
        this.showToast('Success', 'Record saved successfully', 'success');
        this.isModalOpen = false;
        this.refreshList();
    }

    handleSaveError(event) {
        this.showToast('Error', 'Failed to save record: ' + (event?.detail?.detail || event?.detail || ''), 'error');
    }

    // Row selection
    handleRowSelection(event) {
        this.selectedRows = (event.detail.selectedRows || []).map(r => r.Id);
    }

    async handleDeleteSelected() {
        if (!this.selectedRows.length) {
            this.showToast('Error', 'Select at least one record', 'error');
            return;
        }
        this.loading = true;
        try {
            await deleteRecords({ recordIds: this.selectedRows, objectApiName: this.selectedObject });
            this.showToast('Success', 'Selected records deleted', 'success');
            this.selectedRows = [];
            this.refreshList();
        } catch (err) {
            this.showToast('Error', 'Failed to delete: ' + this.getErrorMessage(err), 'error');
        } finally {
            this.loading = false;
        }
    }

    async deleteRecord(recordId) {
        this.loading = true;
        try {
            await deleteRecords({ recordIds: [recordId], objectApiName: this.selectedObject });
            this.showToast('Success', 'Record deleted successfully', 'success');
            this.refreshList();
        } catch (err) {
            this.showToast('Error', 'Failed to delete record: ' + this.getErrorMessage(err), 'error');
        } finally {
            this.loading = false;
        }
    }

    // Row action handler
    handleRowAction(event) {
        const action = event.detail?.action?.name;
        const row = event.detail?.row;
        if (!action || !row) return;

        if (action === 'edit') this.handleEditRow({ detail: { row } });
        else if (action === 'delete') this.deleteRecord(row.Id);
    }

    refreshList() {
        if (this.wiredListViewResult) refreshApex(this.wiredListViewResult);
    }

    showToast(title, message, variant = 'info') {
        this.dispatchEvent(new ShowToastEvent({ title, message, variant }));
    }

    getErrorMessage(err) {
        return err?.body?.message || err?.message || JSON.stringify(err);
    }

    get showNoRecordsMessage() {
        return !this.loading && (!this.rows || this.rows.length === 0);
    }

    get showDatatable() {
        return this.columns && this.rows && this.rows.length > 0;
    }

    get modalTitle() {
        return this.recordForm?.Id ? 'Edit Record' : 'New Record';
    }
}

        
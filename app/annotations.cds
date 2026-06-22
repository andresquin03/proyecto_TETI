using { sap.lcap.ProyectoTETISrv } from '../srv/service.cds';

annotate sap.lcap.ProyectoTETISrv.Incidents with @UI.HeaderInfo: { TypeName: 'Incident', TypeNamePlural: 'Incidents', Title: { Value: title } };
annotate sap.lcap.ProyectoTETISrv.Incidents with {
  ID @UI.Hidden @Common.Text: { $value: title, ![@UI.TextArrangement]: #TextOnly }
};
annotate sap.lcap.ProyectoTETISrv.Incidents with @UI.Identification: [{ Value: title }];
annotate sap.lcap.ProyectoTETISrv.Incidents with {
  customer @Common.ValueList: {
    CollectionPath: 'Customers',
    Parameters    : [
      {
        $Type            : 'Common.ValueListParameterInOut',
        LocalDataProperty: customer_ID, 
        ValueListProperty: 'ID'
      },
      {
        $Type            : 'Common.ValueListParameterDisplayOnly',
        ValueListProperty: 'name'
      },
      {
        $Type            : 'Common.ValueListParameterDisplayOnly',
        ValueListProperty: 'email'
      },
      {
        $Type            : 'Common.ValueListParameterDisplayOnly',
        ValueListProperty: 'phone'
      },
      {
        $Type            : 'Common.ValueListParameterDisplayOnly',
        ValueListProperty: 'createdAt'
      },
      {
        $Type            : 'Common.ValueListParameterDisplayOnly',
        ValueListProperty: 'createdBy'
      },
      {
        $Type            : 'Common.ValueListParameterDisplayOnly',
        ValueListProperty: 'modifiedAt'
      },
      {
        $Type            : 'Common.ValueListParameterDisplayOnly',
        ValueListProperty: 'modifiedBy'
      },
    ],
  }
};
annotate sap.lcap.ProyectoTETISrv.Incidents with {
  title @title: 'Title';
  urgency @title: 'Urgency';
  status @title: 'Status';
  createdAt @title: 'Created At';
  createdBy @title: 'Created By';
  modifiedAt @title: 'Modified At';
  modifiedBy @title: 'Modified By'
};

annotate sap.lcap.ProyectoTETISrv.Incidents with @UI.LineItem: [
 { $Type: 'UI.DataField', Value: title },
 { $Type: 'UI.DataField', Value: urgency },
 { $Type: 'UI.DataField', Value: status },
    { $Type: 'UI.DataField', Label: 'Customer', Value: customer_ID }
];

annotate sap.lcap.ProyectoTETISrv.Incidents with @UI.FieldGroup #Main: {
  $Type: 'UI.FieldGroupType', Data: [
 { $Type: 'UI.DataField', Value: title },
 { $Type: 'UI.DataField', Value: urgency },
 { $Type: 'UI.DataField', Value: status },
 { $Type: 'UI.DataField', Value: createdAt },
 { $Type: 'UI.DataField', Value: createdBy },
 { $Type: 'UI.DataField', Value: modifiedAt },
 { $Type: 'UI.DataField', Value: modifiedBy },
    { $Type: 'UI.DataField', Label: 'Customer', Value: customer_ID }
  ]
};

annotate sap.lcap.ProyectoTETISrv.Incidents with {
  customer @Common.Text: { $value: customer.name, ![@UI.TextArrangement]: #TextOnly }
};

annotate sap.lcap.ProyectoTETISrv.Incidents with {
  customer @Common.Label: 'Customer';
  conversations @Common.Label: 'Conversations'
};

annotate sap.lcap.ProyectoTETISrv.Incidents with @UI.Facets: [
  { $Type: 'UI.ReferenceFacet', ID: 'Main', Label: 'General Information', Target: '@UI.FieldGroup#Main' },
  { $Type : 'UI.ReferenceFacet', ID : 'Conversations', Target : 'conversations/@UI.LineItem' }
];

annotate sap.lcap.ProyectoTETISrv.Incidents with @UI.SelectionFields: [
  customer_ID
];

annotate sap.lcap.ProyectoTETISrv.Customers with @UI.HeaderInfo: { TypeName: 'Customer', TypeNamePlural: 'Customers', Title: { Value: name } };
annotate sap.lcap.ProyectoTETISrv.Customers with {
  ID @UI.Hidden @Common.Text: { $value: name, ![@UI.TextArrangement]: #TextOnly }
};
annotate sap.lcap.ProyectoTETISrv.Customers with @UI.Identification: [{ Value: name }];
annotate sap.lcap.ProyectoTETISrv.Customers with {
  name @title: 'Name';
  email @title: 'Email';
  phone @title: 'Phone';
  createdAt @title: 'Created At';
  createdBy @title: 'Created By';
  modifiedAt @title: 'Modified At';
  modifiedBy @title: 'Modified By'
};

annotate sap.lcap.ProyectoTETISrv.Customers with @UI.LineItem: [
 { $Type: 'UI.DataField', Value: name },
 { $Type: 'UI.DataField', Value: email },
 { $Type: 'UI.DataField', Value: phone }
];

annotate sap.lcap.ProyectoTETISrv.Customers with @UI.FieldGroup #Main: {
  $Type: 'UI.FieldGroupType', Data: [
 { $Type: 'UI.DataField', Value: name },
 { $Type: 'UI.DataField', Value: email },
 { $Type: 'UI.DataField', Value: phone },
 { $Type: 'UI.DataField', Value: createdAt },
 { $Type: 'UI.DataField', Value: createdBy },
 { $Type: 'UI.DataField', Value: modifiedAt },
 { $Type: 'UI.DataField', Value: modifiedBy }
  ]
};

annotate sap.lcap.ProyectoTETISrv.Customers with {
  incidents @Common.Label: 'Incidents'
};

annotate sap.lcap.ProyectoTETISrv.Customers with @UI.Facets: [
  { $Type: 'UI.ReferenceFacet', ID: 'Main', Label: 'General Information', Target: '@UI.FieldGroup#Main' }
];

annotate sap.lcap.ProyectoTETISrv.Customers with @UI.SelectionFields: [
  name
];

annotate sap.lcap.ProyectoTETISrv.Conversations with @UI.HeaderInfo: { TypeName: 'Conversation', TypeNamePlural: 'Conversations' };
annotate sap.lcap.ProyectoTETISrv.Conversations with {
  incident @Common.ValueList: {
    CollectionPath: 'Incidents',
    Parameters    : [
      {
        $Type            : 'Common.ValueListParameterInOut',
        LocalDataProperty: incident_ID, 
        ValueListProperty: 'ID'
      },
      {
        $Type            : 'Common.ValueListParameterDisplayOnly',
        ValueListProperty: 'title'
      },
      {
        $Type            : 'Common.ValueListParameterDisplayOnly',
        ValueListProperty: 'urgency'
      },
      {
        $Type            : 'Common.ValueListParameterDisplayOnly',
        ValueListProperty: 'status'
      },
      {
        $Type            : 'Common.ValueListParameterDisplayOnly',
        ValueListProperty: 'createdAt'
      },
      {
        $Type            : 'Common.ValueListParameterDisplayOnly',
        ValueListProperty: 'createdBy'
      },
      {
        $Type            : 'Common.ValueListParameterDisplayOnly',
        ValueListProperty: 'modifiedAt'
      },
      {
        $Type            : 'Common.ValueListParameterDisplayOnly',
        ValueListProperty: 'modifiedBy'
      },
    ],
  }
};
annotate sap.lcap.ProyectoTETISrv.Conversations with @UI.DataPoint #message: {
  Value: message,
  Title: 'Message',
};
annotate sap.lcap.ProyectoTETISrv.Conversations with {
  message @title: 'Message';
  timestamp @title: 'Timestamp';
  createdAt @title: 'Created At';
  createdBy @title: 'Created By';
  modifiedAt @title: 'Modified At';
  modifiedBy @title: 'Modified By'
};

annotate sap.lcap.ProyectoTETISrv.Conversations with @UI.LineItem: [
 { $Type: 'UI.DataField', Value: message },
 { $Type: 'UI.DataField', Value: timestamp }
];

annotate sap.lcap.ProyectoTETISrv.Conversations with @UI.FieldGroup #Main: {
  $Type: 'UI.FieldGroupType', Data: [
 { $Type: 'UI.DataField', Value: message },
 { $Type: 'UI.DataField', Value: timestamp },
 { $Type: 'UI.DataField', Value: createdAt },
 { $Type: 'UI.DataField', Value: createdBy },
 { $Type: 'UI.DataField', Value: modifiedAt },
 { $Type: 'UI.DataField', Value: modifiedBy }
  ]
};

annotate sap.lcap.ProyectoTETISrv.Conversations with {
  incident @Common.Text: { $value: incident.title, ![@UI.TextArrangement]: #TextOnly }
};

annotate sap.lcap.ProyectoTETISrv.Conversations with {
  incident @Common.Label: 'Incident'
};

annotate sap.lcap.ProyectoTETISrv.Conversations with @UI.HeaderFacets: [
 { $Type : 'UI.ReferenceFacet', Target : '@UI.DataPoint#message' }
];

annotate sap.lcap.ProyectoTETISrv.Conversations with @UI.Facets: [
  { $Type: 'UI.ReferenceFacet', ID: 'Main', Label: 'General Information', Target: '@UI.FieldGroup#Main' }
];

annotate sap.lcap.ProyectoTETISrv.Conversations with @UI.SelectionFields: [
  incident_ID
];


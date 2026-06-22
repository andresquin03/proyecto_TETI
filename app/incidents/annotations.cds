using ProcessorService as service from '../../srv/service';
using from '../../db/schema';

annotate service.Incidents with @(
    UI.HeaderInfo : {
        TypeName : '{i18n>Incident}',
        TypeNamePlural : '{i18n>Incidents}',
        Title : { Value : title },
        Description : { Value : status.descr },
    },
    UI.FieldGroup #GeneratedGroup : {
        $Type : 'UI.FieldGroupType',
        Data : [
            {
                $Type : 'UI.DataField',
                Value : title,
            },
            {
                $Type : 'UI.DataField',
                Label : '{i18n>Customer}',
                Value : customer_ID,
            },
            {
                $Type : 'UI.DataField',
                Label : '{i18n>Urgency}',
                Value : urgency_code,
                Criticality : urgencyCriticality,
            },
            {
                $Type : 'UI.DataField',
                Label : '{i18n>Status}',
                Value : status_code,
                Criticality : statusCriticality,
            },
            {
                $Type : 'UI.DataField',
                Label : '{i18n>Open}',
                Value : isOpen,
            },
        ],
    },
    UI.FieldGroup #Admin : {
        $Type : 'UI.FieldGroupType',
        Data : [
            { $Type : 'UI.DataField', Value : createdBy },
            { $Type : 'UI.DataField', Value : createdAt },
            { $Type : 'UI.DataField', Value : modifiedBy },
            { $Type : 'UI.DataField', Value : modifiedAt },
        ],
    },
    UI.Facets : [
        {
            $Type : 'UI.ReferenceFacet',
            ID : 'GeneratedFacet1',
            Label : '{i18n>GeneralInformation}',
            Target : '@UI.FieldGroup#GeneratedGroup',
        },
        {
            $Type : 'UI.ReferenceFacet',
            ID : 'AdminFacet',
            Label : '{i18n>AdministrativeData}',
            Target : '@UI.FieldGroup#Admin',
        },
        {
            $Type : 'UI.ReferenceFacet',
            ID : 'ConversationFacet',
            Label : '{i18n>Conversation}',
            Target : 'conversation/@UI.LineItem',
        },
    ],
    UI.LineItem : [
        {
            $Type : 'UI.DataField',
            Value : title,
            Importance : #High,
        },
        {
            $Type : 'UI.DataField',
            Value : customer.name,
            Label : '{i18n>Customer}',
            Importance : #High,
        },
        {
            $Type : 'UI.DataField',
            Value : urgency.descr,
            Criticality : urgencyCriticality,
            Label : '{i18n>Urgency}',
            Importance : #Medium,
        },
        {
            $Type : 'UI.DataField',
            Value : status.descr,
            Criticality : statusCriticality,
            Label : '{i18n>Status}',
            Importance : #High,
        },
    ],
    UI.SelectionFields : [
        status_code,
        urgency_code,
        customer_ID,
    ],
);

annotate service.Incidents with {
    customer @Common.ValueList : {
        $Type : 'Common.ValueListType',
        CollectionPath : 'Customers',
        Parameters : [
            {
                $Type : 'Common.ValueListParameterInOut',
                LocalDataProperty : customer_ID,
                ValueListProperty : 'ID',
            },
            {
                $Type : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty : 'firstName',
            },
            {
                $Type : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty : 'lastName',
            },
            {
                $Type : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty : 'name',
            },
            {
                $Type : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty : 'email',
            },
        ],
    }
};

annotate service.Incidents with {
    customer @(
        Common.Text : customer.name,
        Common.TextArrangement : #TextOnly,
        Common.Label : '{i18n>Customer}',
    )
};

annotate service.Incidents with {
    status @(
        Common.Text : status.descr,
        Common.TextArrangement : #TextOnly,
        Common.Label : '{i18n>Status}',
        Common.ValueListWithFixedValues : true,
    )
};

annotate service.Incidents with {
    urgency @(
        Common.Text : urgency.descr,
        Common.TextArrangement : #TextOnly,
        Common.Label : '{i18n>Urgency}',
        Common.ValueListWithFixedValues : true,
    )
};

annotate service.Status with {
    code @(
        Common.Text : descr,
        Common.TextArrangement : #TextOnly,
    )
};

annotate service.Urgency with {
    code @(
        Common.Text : descr,
        Common.TextArrangement : #TextOnly,
    )
};

// Tabla de conversación (composición de Incidents) mostrada como facet en la Object Page.
annotate service.Incidents.conversation with @(
    UI.HeaderInfo : {
        TypeName : '{i18n>Message}',
        TypeNamePlural : '{i18n>Conversation}',
    },
    UI.LineItem : [
        {
            $Type : 'UI.DataField',
            Value : timestamp,
            Label : '{i18n>Timestamp}',
        },
        {
            $Type : 'UI.DataField',
            Value : author,
            Label : '{i18n>Author}',
        },
        {
            $Type : 'UI.DataField',
            Value : message,
            Label : '{i18n>Message}',
            Importance : #High,
        },
    ],
) {
    message @Common.Label : '{i18n>Message}';
    author @Common.Label : '{i18n>Author}';
    timestamp @Common.Label : '{i18n>Timestamp}';
};

// Etiquetas legibles para los campos de Customer (se ven en la ayuda de valores / value help).
annotate service.Customers with {
    firstName @Common.Label : '{i18n>FirstName}';
    lastName  @Common.Label : '{i18n>LastName}';
    name      @Common.Label : '{i18n>Name}';
    email     @Common.Label : '{i18n>Email}';
    phone     @Common.Label : '{i18n>Phone}';
};
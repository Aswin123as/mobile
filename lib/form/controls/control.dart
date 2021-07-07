import 'package:flutter/material.dart';
import 'package:frappe_app/config/frappe_palette.dart';

import 'package:frappe_app/config/palette.dart';
import 'package:frappe_app/form/controls/read_only.dart';
import 'package:frappe_app/form/controls/text.dart';
import 'package:frappe_app/model/config.dart';
import 'package:frappe_app/model/doctype_response.dart';
import 'package:frappe_app/utils/enums.dart';
import 'package:frappe_app/widgets/custom_expansion_tile.dart';
import 'package:frappe_app/widgets/section.dart';

import '../../config/palette.dart';

import './custom_table.dart';
import './check.dart';
import './data.dart';
import './date.dart';
import './datetime.dart';
import './float.dart';
import './int.dart';
import './select.dart';
import './small_text.dart';
import './text_editor.dart';
import './time.dart';
import './autocomplete.dart';
import './link_field.dart';
import './multi_select.dart';

Widget makeControl({
  required DoctypeField field,
  Map? doc,
  bool decorateControl = true,
}) {
  Widget control;

  switch (field.fieldtype) {
    case "Link":
      {
        control = LinkField(
          doctypeField: field,
          doc: doc,
        );
      }
      break;

    case "Autocomplete":
      {
        control = AutoComplete(
          doctypeField: field,
          doc: doc,
        );
      }
      break;

    case "Table":
      {
        control = CustomTable(
          doctypeField: field,
          doc: doc,
        );
      }
      break;

    case "Select":
      {
        control = Select(
          doc: doc,
          doctypeField: field,
        );
      }
      break;

    case "MultiSelect":
      {
        control = MultiSelect(
          doctypeField: field,
          doc: doc,
        );
      }
      break;

    case "Small Text":
      {
        control = SmallText(
          doctypeField: field,
          doc: doc,
        );
      }
      break;

    case "Text":
      {
        control = ControlText(
          doctypeField: field,
          doc: doc,
        );
      }
      break;

    case "Data":
      {
        control = Data(
          doc: doc,
          doctypeField: field,
        );
      }
      break;

    case "Read Only":
      {
        control = ReadOnly(
          doc: doc,
          doctypeField: field,
        );
      }
      break;

    case "Check":
      {
        control = Check(
          doctypeField: field,
          doc: doc,
        );
      }
      break;

    case "Text Editor":
      {
        control = TextEditor(
          doctypeField: field,
          doc: doc,
        );
      }
      break;

    case "Datetime":
      {
        control = DatetimeField(
          doctypeField: field,
          doc: doc,
        );
      }
      break;

    case "Float":
      {
        control = Float(
          doctypeField: field,
          doc: doc,
        );
      }
      break;

    case "Int":
      {
        control = Int(
          doctypeField: field,
          doc: doc,
        );
      }
      break;

    case "Time":
      {
        control = Time(
          doctypeField: field,
          doc: doc,
        );
      }
      break;

    case "Date":
      {
        control = Date(
          doctypeField: field,
          doc: doc,
        );
      }
      break;

    // case "Signature":
    //   {
    //     control = customSignature.Signature(
    //       doc: doc,
    //       doctypeField: field,
    //     );
    //   }
    //   break;

    // case "Barcode":
    //   {
    //     control = FormBuilderBarcode(
    //       doctypeField: field,
    //       doc: doc,
    //     );
    //   }
    //   break;

    default:
      control = Container();
      break;
  }
  if (decorateControl && field.fieldtype != "Check") {
    return buildDecoratedControl(
      control: control,
      field: field,
    );
  } else {
    return Padding(
      padding: Palette.fieldPadding,
      child: control,
    );
  }
}

Widget buildDecoratedControl({
  required Widget control,
  required DoctypeField field,
}) {
  return Padding(
    padding: Palette.fieldPadding,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: [
            Padding(
              padding: Palette.labelPadding,
              child: Text(
                field.label ?? "",
                style: Palette.secondaryTxtStyle,
              ),
            ),
            SizedBox(width: 4),
            if (field.reqd == 1)
              Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: Text(
                  '*',
                  style: TextStyle(
                    color: FrappePalette.red,
                  ),
                ),
              ),
          ],
        ),
        control
      ],
    ),
  );
}

List<Widget> generateLayout({
  required List<DoctypeField> fields,
  ViewType? viewType,
  Map? doc,
  bool editMode = true,
}) {
  List<Widget> collapsibles = [];
  List<Widget> widgets = [];
  List<Widget> sections = [];

  List<String> collapsibleLabels = [];
  List<String> sectionLabels = [];

  var isCollapsible = false;
  var isSection = false;

  int cIdx = 0;
  int sIdx = 0;

  fields.forEach((field) {
    var val;
    var defaultValDoc = {};

    if (doc != null) {
      val = doc[field.fieldname];
    } else {
      val = field.defaultValue;

      if (val == '__user') {
        val = Config().userId;
      }

      defaultValDoc = {
        field.fieldname: val,
      };
    }

    if (val is List) {
      if (val.isEmpty) {
        val = null;
      }
    }

    if (field.fieldtype == "Section Break") {
      if (sections.length > 0) {
        var sectionVisibility = sections.any((element) {
          if (element is Visibility) {
            return element.visible == true;
          } else {
            return true;
          }
        });

        widgets.add(
          Visibility(
            visible: sectionVisibility,
            child: sectionLabels[sIdx] != ''
                ? ListTileTheme(
                    contentPadding: EdgeInsets.all(0),
                    child: CustomExpansionTile(
                      maintainState: true,
                      initiallyExpanded: true,
                      title: Text(
                        sectionLabels[sIdx],
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                      children: [...sections],
                    ),
                  )
                : Section(
                    title: sectionLabels[sIdx],
                    children: [...sections],
                  ),
          ),
        );

        sIdx += 1;
        sections.clear();
      } else if (collapsibles.length > 0) {
        var sectionVisibility = collapsibles.any((element) {
          if (element is Visibility) {
            return element.visible == true;
          } else {
            return true;
          }
        });
        widgets.add(
          Visibility(
            visible: sectionVisibility,
            child: ListTileTheme(
              contentPadding: EdgeInsets.all(0),
              child: CustomExpansionTile(
                maintainState: true,
                title: Text(
                  collapsibleLabels[cIdx],
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
                children: [...collapsibles],
              ),
            ),
          ),
        );
        cIdx += 1;
        collapsibles.clear();
      }

      if (field.collapsible == 1) {
        isSection = false;
        isCollapsible = true;
        collapsibleLabels.add(field.label!);
      } else {
        isCollapsible = false;
        isSection = true;
        sectionLabels.add(field.label != null ? field.label! : '');
      }
    } else if (isSection) {
      if (viewType == ViewType.form) {
        sections.add(
          Visibility(
            visible: editMode ? true : val != null && val != '',
            child: makeControl(
              doc: doc,
              field: field,
            ),
          ),
        );
      } else {
        sections.add(
          makeControl(
            field: field,
            doc: doc,
          ),
        );
      }
    } else if (isCollapsible) {
      if (viewType == ViewType.form) {
        collapsibles.add(
          Visibility(
            visible: editMode ? true : val != null && val != '',
            child: makeControl(
              field: field,
              doc: doc ?? defaultValDoc,
            ),
          ),
        );
      } else {
        collapsibles.add(
          makeControl(
            doc: doc ?? defaultValDoc,
            field: field,
          ),
        );
      }
    } else {
      if (viewType == ViewType.form) {
        widgets.add(
          Visibility(
            visible: editMode ? true : val != null && val != '',
            child: makeControl(
              doc: doc ?? defaultValDoc,
              field: field,
            ),
          ),
        );
      } else {
        widgets.add(
          makeControl(
            field: field,
            doc: doc ?? defaultValDoc,
          ),
        );
      }
    }
  });

  if (collapsibles.length > 0) {
    var sectionVisibility = collapsibles.any((element) {
      if (element is Visibility) {
        return element.visible == true;
      } else {
        return true;
      }
    });
    widgets.add(
      Visibility(
        visible: sectionVisibility,
        child: ListTileTheme(
          contentPadding: EdgeInsets.all(0),
          child: CustomExpansionTile(
            maintainState: true,
            title: Text(
              collapsibleLabels[cIdx],
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
            ),
            children: [...collapsibles],
          ),
        ),
      ),
    );
    cIdx += 1;
    collapsibles.clear();
  }

  return widgets;
}

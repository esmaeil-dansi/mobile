import 'package:flutter/cupertino.dart';
import 'package:frappe_app/model/agentInfo.dart';
import 'package:frappe_app/widgets/form/CustomTextFormField.dart';

Widget agentInfoWidget(AgentInfo agentInfo) => Column(
      children: [
        if (agentInfo.full_name.isNotEmpty)
          Padding(
            padding: EdgeInsets.symmetric(vertical: 5),
            child: CustomTextFormField(
              height: 70,
              readOnly: true,
              value: agentInfo.full_name,
              label: "نام و نام خانوادگی",
            ),
          ),
        if (agentInfo.province.isNotEmpty)
          Padding(
            padding: EdgeInsets.symmetric(vertical: 5),
            child: CustomTextFormField(
              height: 70,
              readOnly: true,
              value: agentInfo.province,
              label: "استان",
            ),
          ),
        if (agentInfo.city.isNotEmpty)
          Padding(
            padding: EdgeInsets.symmetric(vertical: 5),
            child: CustomTextFormField(
              height: 70,
              readOnly: true,
              maxLine: 3,
              value: agentInfo.city,
              label: "شهرستان",
            ),
          ),
        if (agentInfo.mobile.isNotEmpty)
          Padding(
            padding: EdgeInsets.symmetric(vertical: 5),
            child: CustomTextFormField(
              height: 70,
              readOnly: true,
              value: agentInfo.mobile,
              label: "َشماره تلفن",
            ),
          ),
        if (agentInfo.rahbar.isNotEmpty)
          Padding(
            padding: EdgeInsets.symmetric(vertical: 5),
            child: CustomTextFormField(
              height: 70,
              readOnly: true,
              value: agentInfo.rahbar,
              label: "َراهبر اصلی",
            ),
          ),
        if (agentInfo.department.isNotEmpty)
          Padding(
            padding: EdgeInsets.symmetric(vertical: 5),
            child: CustomTextFormField(
              height: 70,
              readOnly: true,
              value: agentInfo.department,
              label: "اداره کمیته امداد",
            ),
          ),
      ],
    );

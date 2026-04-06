package com.example.login_and_course.service;

import com.example.login_and_course.pojo.Login;

import java.util.Arrays;
import java.util.Collections;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.regex.Pattern;

public class LoginFormValidator {
    private static final Pattern PASSWORD_PATTERN = Pattern.compile("^(?=.*[A-Za-z])(?=.*\\d).+$");
    private static final Pattern CAPTCHA_PATTERN = Pattern.compile("^[A-Za-z0-9]{4}$");
    private static final Map<String, List<String>> COLLEGE_DEPARTMENT_MAP = buildCollegeDepartmentMap();

    public String validate(Login login, String captcha) {
        if (login == null) {
            return "登录信息不能为空。";
        }

        if (isBlank(login.getUserName()) || isBlank(login.getPassword())
                || isBlank(login.getCollege()) || isBlank(login.getDepartment()) || isBlank(captcha)) {
            return "请完整填写登录信息和验证码。";
        }

        if (login.getUserName().length() > 20) {
            return "用户名长度不能超过20个字符。";
        }

        if (!PASSWORD_PATTERN.matcher(login.getPassword()).matches()) {
            return "密码必须同时包含字母和数字。";
        }

        List<String> departments = COLLEGE_DEPARTMENT_MAP.get(login.getCollege());
        if (departments == null) {
            return "请选择有效的学院。";
        }

        if (!departments.contains(login.getDepartment())) {
            return "请选择与学院匹配的系。";
        }

        if (!CAPTCHA_PATTERN.matcher(captcha).matches()) {
            return "验证码必须为4位字母或数字。";
        }

        return null;
    }

    public static Map<String, List<String>> getCollegeDepartmentMap() {
        return COLLEGE_DEPARTMENT_MAP;
    }

    public static boolean isPasswordValid(String password) {
        return password != null && PASSWORD_PATTERN.matcher(password).matches();
    }

    private static Map<String, List<String>> buildCollegeDepartmentMap() {
        LinkedHashMap<String, List<String>> collegeDepartmentMap = new LinkedHashMap<>();
        collegeDepartmentMap.put("计算机学院", Collections.unmodifiableList(Arrays.asList(
                "软件工程",
                "计算机科学与技术",
                "数据科学与大数据技术"
        )));
        collegeDepartmentMap.put("经济管理学院", Collections.unmodifiableList(Arrays.asList(
                "工商管理",
                "会计学",
                "市场营销"
        )));
        collegeDepartmentMap.put("外国语学院", Collections.unmodifiableList(Arrays.asList(
                "英语",
                "商务英语",
                "日语"
        )));
        return Collections.unmodifiableMap(collegeDepartmentMap);
    }

    private boolean isBlank(String value) {
        return value == null || value.trim().isEmpty();
    }
}

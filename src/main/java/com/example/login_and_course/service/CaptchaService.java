package com.example.login_and_course.service;

import jakarta.servlet.http.HttpSession;

import java.security.SecureRandom;

public class CaptchaService {
    public static final int CAPTCHA_LENGTH = 4;
    private static final String CAPTCHA_SOURCE = "ABCDEFGHJKLMNPQRSTUVWXYZ23456789";
    private static final String CAPTCHA_CODE_SESSION_KEY = "captchaCode";
    private static final String CAPTCHA_TIME_SESSION_KEY = "captchaCreateTime";
    private static final long CAPTCHA_EXPIRE_MILLIS = 2 * 60 * 1000L;
    private final SecureRandom secureRandom = new SecureRandom();

    public String issueCaptcha(HttpSession session) {
        if (session == null) {
            throw new IllegalArgumentException("session cannot be null");
        }

        String captchaCode = buildCaptchaCode();
        session.setAttribute(CAPTCHA_CODE_SESSION_KEY, captchaCode);
        session.setAttribute(CAPTCHA_TIME_SESSION_KEY, System.currentTimeMillis());
        return captchaCode;
    }

    public CaptchaValidationStatus validateCaptcha(HttpSession session, String inputCaptcha) {
        if (session == null) {
            return CaptchaValidationStatus.MISSING;
        }

        String sessionCaptcha = trim((String) session.getAttribute(CAPTCHA_CODE_SESSION_KEY));
        Object captchaTimeValue = session.getAttribute(CAPTCHA_TIME_SESSION_KEY);
        if (sessionCaptcha.isEmpty() || !(captchaTimeValue instanceof Number)) {
            clearCaptcha(session);
            return CaptchaValidationStatus.MISSING;
        }

        long captchaCreateTime = ((Number) captchaTimeValue).longValue();
        if (System.currentTimeMillis() - captchaCreateTime > CAPTCHA_EXPIRE_MILLIS) {
            clearCaptcha(session);
            return CaptchaValidationStatus.EXPIRED;
        }

        if (!sessionCaptcha.equalsIgnoreCase(trim(inputCaptcha))) {
            clearCaptcha(session);
            return CaptchaValidationStatus.MISMATCH;
        }

        clearCaptcha(session);
        return CaptchaValidationStatus.VALID;
    }

    public void clearCaptcha(HttpSession session) {
        if (session == null) {
            return;
        }
        session.removeAttribute(CAPTCHA_CODE_SESSION_KEY);
        session.removeAttribute(CAPTCHA_TIME_SESSION_KEY);
    }

    private String buildCaptchaCode() {
        StringBuilder builder = new StringBuilder(CAPTCHA_LENGTH);
        for (int i = 0; i < CAPTCHA_LENGTH; i++) {
            int index = secureRandom.nextInt(CAPTCHA_SOURCE.length());
            builder.append(CAPTCHA_SOURCE.charAt(index));
        }
        return builder.toString();
    }

    private String trim(String value) {
        return value == null ? "" : value.trim();
    }

    public enum CaptchaValidationStatus {
        VALID,
        MISSING,
        EXPIRED,
        MISMATCH
    }
}

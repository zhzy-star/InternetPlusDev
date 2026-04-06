package com.example.login_and_course.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import javax.imageio.ImageIO;
import java.awt.Color;
import java.awt.Font;
import java.awt.Graphics2D;
import java.awt.RenderingHints;
import java.awt.image.BufferedImage;
import java.io.IOException;
import java.security.SecureRandom;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet(name = "captchaController", value = "/CaptchaController")
public class CaptchaController extends HttpServlet {
    private static final String CAPTCHA_SESSION_KEY = "captchaCode";
    private static final String CAPTCHA_SOURCE = "ABCDEFGHJKLMNPQRSTUVWXYZ23456789";
    private static final int CAPTCHA_LENGTH = 4;
    private static final int IMAGE_WIDTH = 120;
    private static final int IMAGE_HEIGHT = 42;
    private static final Logger LOGGER = Logger.getLogger(CaptchaController.class.getName());
    private final SecureRandom random = new SecureRandom();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String captchaCode = generateCaptchaCode();
            HttpSession session = request.getSession();
            session.setAttribute(CAPTCHA_SESSION_KEY, captchaCode);

            BufferedImage image = new BufferedImage(IMAGE_WIDTH, IMAGE_HEIGHT, BufferedImage.TYPE_INT_RGB);
            Graphics2D graphics = image.createGraphics();
            try {
                renderCaptchaImage(graphics, captchaCode);
            } finally {
                graphics.dispose();
            }

            response.setContentType("image/png");
            response.setHeader("Cache-Control", "no-store, no-cache, must-revalidate, max-age=0");
            response.setHeader("Pragma", "no-cache");
            response.setDateHeader("Expires", 0);
            response.setHeader("X-Content-Type-Options", "nosniff");
            ImageIO.write(image, "png", response.getOutputStream());
        } catch (IOException e) {
            LOGGER.log(Level.WARNING, "Failed to write captcha response", e);
            throw e;
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Failed to generate captcha", e);
            if (!response.isCommitted()) {
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "验证码生成失败");
            }
        }
    }

    private String generateCaptchaCode() {
        StringBuilder captchaBuilder = new StringBuilder(CAPTCHA_LENGTH);
        for (int i = 0; i < CAPTCHA_LENGTH; i++) {
            int index = random.nextInt(CAPTCHA_SOURCE.length());
            captchaBuilder.append(CAPTCHA_SOURCE.charAt(index));
        }
        return captchaBuilder.toString();
    }

    private void renderCaptchaImage(Graphics2D graphics, String captchaCode) {
        graphics.setRenderingHint(RenderingHints.KEY_ANTIALIASING, RenderingHints.VALUE_ANTIALIAS_ON);
        graphics.setColor(new Color(250, 250, 250));
        graphics.fillRect(0, 0, IMAGE_WIDTH, IMAGE_HEIGHT);

        graphics.setColor(new Color(170, 170, 170));
        graphics.drawRect(0, 0, IMAGE_WIDTH - 1, IMAGE_HEIGHT - 1);

        graphics.setColor(new Color(70, 70, 70));
        graphics.setFont(new Font("Arial", Font.BOLD, 26));
        for (int i = 0; i < captchaCode.length(); i++) {
            graphics.drawString(String.valueOf(captchaCode.charAt(i)), 16 + i * 22, 29 + random.nextInt(5));
        }

        graphics.setColor(new Color(150, 150, 150));
        graphics.drawLine(10, 12, 108, 30);
        graphics.drawLine(12, 32, 110, 16);
    }
}

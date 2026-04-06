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
import java.util.Random;

@WebServlet(name = "captchaController", value = "/CaptchaController")
public class CaptchaController extends HttpServlet {
    private static final String CAPTCHA_SESSION_KEY = "captchaCode";
    private static final String CAPTCHA_SOURCE = "ABCDEFGHJKLMNPQRSTUVWXYZ23456789";
    private static final int CAPTCHA_LENGTH = 4;
    private static final int IMAGE_WIDTH = 120;
    private static final int IMAGE_HEIGHT = 42;
    private final Random random = new Random();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        BufferedImage image = new BufferedImage(IMAGE_WIDTH, IMAGE_HEIGHT, BufferedImage.TYPE_INT_RGB);
        Graphics2D graphics = image.createGraphics();

        try {
            paintBackground(graphics);
            drawNoise(graphics);

            String captchaCode = generateCaptchaCode();
            HttpSession session = request.getSession();
            session.setAttribute(CAPTCHA_SESSION_KEY, captchaCode);

            drawCaptchaText(graphics, captchaCode);

            response.setContentType("image/png");
            response.setHeader("Cache-Control", "no-store, no-cache, must-revalidate");
            response.setHeader("Pragma", "no-cache");
            response.setDateHeader("Expires", 0);
            ImageIO.write(image, "png", response.getOutputStream());
        } finally {
            graphics.dispose();
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

    private void paintBackground(Graphics2D graphics) {
        graphics.setRenderingHint(RenderingHints.KEY_ANTIALIASING, RenderingHints.VALUE_ANTIALIAS_ON);
        graphics.setColor(new Color(242, 248, 255));
        graphics.fillRect(0, 0, IMAGE_WIDTH, IMAGE_HEIGHT);
        graphics.setColor(new Color(191, 212, 236));
        graphics.drawRoundRect(0, 0, IMAGE_WIDTH - 1, IMAGE_HEIGHT - 1, 10, 10);
    }

    private void drawNoise(Graphics2D graphics) {
        for (int i = 0; i < 10; i++) {
            graphics.setColor(new Color(160 + random.nextInt(50), 180 + random.nextInt(50), 200 + random.nextInt(40)));
            int x1 = random.nextInt(IMAGE_WIDTH);
            int y1 = random.nextInt(IMAGE_HEIGHT);
            int x2 = random.nextInt(IMAGE_WIDTH);
            int y2 = random.nextInt(IMAGE_HEIGHT);
            graphics.drawLine(x1, y1, x2, y2);
        }

        for (int i = 0; i < 30; i++) {
            graphics.setColor(new Color(140 + random.nextInt(70), 170 + random.nextInt(60), 190 + random.nextInt(50)));
            int x = random.nextInt(IMAGE_WIDTH);
            int y = random.nextInt(IMAGE_HEIGHT);
            graphics.fillOval(x, y, 2, 2);
        }
    }

    private void drawCaptchaText(Graphics2D graphics, String captchaCode) {
        graphics.setFont(new Font("Arial", Font.BOLD, 26));
        for (int i = 0; i < captchaCode.length(); i++) {
            graphics.setColor(new Color(30 + random.nextInt(80), 60 + random.nextInt(80), 100 + random.nextInt(80)));
            int x = 18 + i * 22;
            int y = 29 + random.nextInt(6);
            graphics.drawString(String.valueOf(captchaCode.charAt(i)), x, y);
        }
    }
}

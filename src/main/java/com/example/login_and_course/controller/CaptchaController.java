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
        String captchaCode = generateCaptchaCode();
        HttpSession session = request.getSession();
        session.setAttribute(CAPTCHA_SESSION_KEY, captchaCode);

        BufferedImage image = new BufferedImage(IMAGE_WIDTH, IMAGE_HEIGHT, BufferedImage.TYPE_INT_RGB);
        Graphics2D graphics = image.createGraphics();

        try {
            graphics.setColor(Color.WHITE);
            graphics.fillRect(0, 0, IMAGE_WIDTH, IMAGE_HEIGHT);

            graphics.setColor(Color.BLACK);
            graphics.drawRect(0, 0, IMAGE_WIDTH - 1, IMAGE_HEIGHT - 1);
            graphics.setFont(new Font("Arial", Font.BOLD, 28));
            graphics.drawString(captchaCode, 18, 30);

            graphics.setColor(Color.GRAY);
            graphics.drawLine(10, 10, 100, 30);

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
}

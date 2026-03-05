package mg.universite.service;

import jakarta.mail.Message;
import jakarta.mail.PasswordAuthentication;
import jakarta.mail.Session;
import jakarta.mail.Transport;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;

import java.net.URLDecoder;
import java.nio.charset.StandardCharsets;
import java.util.Properties;

public class EmailService {

    private static class SmtpConfig {
        final String host;
        final int port;
        final String username;
        final String password;
        final boolean startTls;

        SmtpConfig(String host, int port, String username, String password, boolean startTls) {
            this.host = host;
            this.port = port;
            this.username = username;
            this.password = password;
            this.startTls = startTls;
        }
    }

    public void sendStudentCredentials(String toEmail, String numeroEtudiant, String plainPassword, String loginUrl) {
        if (toEmail == null || toEmail.isBlank()) {
            throw new IllegalArgumentException("Email destinataire requis");
        }

        SmtpConfig cfg = loadConfigFromEnv();

        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", cfg.startTls ? "true" : "false");
        props.put("mail.smtp.starttls.required", cfg.startTls ? "true" : "false");
        props.put("mail.smtp.host", cfg.host);
        props.put("mail.smtp.port", String.valueOf(cfg.port));
        props.put("mail.smtp.ssl.trust", cfg.host);

        Session session = Session.getInstance(props, new jakarta.mail.Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(cfg.username, cfg.password);
            }
        });

        try {
            MimeMessage message = new MimeMessage(session);
            message.setFrom(new InternetAddress(cfg.username));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
            message.setSubject("Vos accès - Mada U", "UTF-8");

            String body = "Bonjour,\n\n" +
                    "Votre compte étudiant a été créé sur la plateforme Mada U.\n\n" +
                    "Numéro étudiant: " + safe(numeroEtudiant) + "\n" +
                    "Email: " + toEmail + "\n" +
                    "Mot de passe temporaire: " + safe(plainPassword) + "\n\n" +
                    "Lien de connexion: " + safe(loginUrl) + "\n\n" +
                    "Merci.";

            message.setText(body, "UTF-8");
            Transport.send(message);
        } catch (Exception e) {
            throw new RuntimeException("Erreur lors de l'envoi de l'email: " + e.getMessage(), e);
        }
    }

    private static String safe(String v) {
        return v == null ? "" : v;
    }

    private SmtpConfig loadConfigFromEnv() {
        String dsn = System.getenv("MAILER_DSN");
        if (dsn != null && !dsn.isBlank()) {
            try {
                return parseMailerDsn(dsn.trim());
            } catch (IllegalArgumentException ignored) {
                // Fallback to SMTP_* if provided
            }
        }

        String host = getenvOrDefault("SMTP_HOST", "smtp.gmail.com");
        int port = Integer.parseInt(getenvOrDefault("SMTP_PORT", "587"));
        String user = System.getenv("SMTP_USER");
        String pass = System.getenv("SMTP_PASS");
        if (user == null || user.isBlank() || pass == null || pass.isBlank()) {
            if (dsn != null && !dsn.isBlank()) {
                return parseMailerDsn(dsn.trim());
            }
            throw new IllegalStateException("MAILER_DSN ou SMTP_USER/SMTP_PASS requis pour l'envoi email");
        }
        return new SmtpConfig(host, port, user, pass, true);
    }

    private static String getenvOrDefault(String key, String def) {
        String v = System.getenv(key);
        return (v == null || v.isBlank()) ? def : v;
    }

    private static SmtpConfig parseMailerDsn(String dsn) {
        try {
            if (dsn == null) {
                throw new IllegalArgumentException("MAILER_DSN vide");
            }
            String raw = dsn.trim();
            String lower = raw.toLowerCase();
            if (!lower.startsWith("smtp://") && !lower.startsWith("smtps://")) {
                throw new IllegalArgumentException("MAILER_DSN doit commencer par smtp://");
            }

            String withoutScheme = raw.substring(raw.indexOf("://") + 3);
            int at = withoutScheme.lastIndexOf('@');
            if (at <= 0) {
                throw new IllegalArgumentException("MAILER_DSN doit contenir user:pass");
            }

            String userPass = withoutScheme.substring(0, at);
            String hostPort = withoutScheme.substring(at + 1);

            int colonCreds = userPass.indexOf(':');
            if (colonCreds <= 0) {
                throw new IllegalArgumentException("MAILER_DSN doit contenir user:pass");
            }

            String userEnc = userPass.substring(0, colonCreds);
            String passEnc = userPass.substring(colonCreds + 1);
            String user = URLDecoder.decode(userEnc, StandardCharsets.UTF_8);
            String pass = URLDecoder.decode(passEnc, StandardCharsets.UTF_8);

            String host;
            int port = 587;
            int colonHost = hostPort.lastIndexOf(':');
            if (colonHost > 0 && colonHost < hostPort.length() - 1) {
                host = hostPort.substring(0, colonHost);
                try {
                    port = Integer.parseInt(hostPort.substring(colonHost + 1));
                } catch (Exception ignored) {
                    port = 587;
                }
            } else {
                host = hostPort;
            }

            if (host == null || host.isBlank()) {
                throw new IllegalArgumentException("Host SMTP manquant");
            }
            return new SmtpConfig(host, port, user, pass, true);
        } catch (Exception e) {
            throw new IllegalArgumentException("MAILER_DSN invalide: " + e.getMessage(), e);
        }
    }
}

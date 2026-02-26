package mg.universite.service;

import mg.universite.dao.RoleDAO;
import mg.universite.dao.UserDAO;
import mg.universite.model.Role;
import mg.universite.model.User;

public class AuthService {

    public static final String ROLE_ADMIN = "ADMIN";
    public static final String ROLE_USER = "USER";

    private final UserDAO userDAO;
    private final RoleDAO roleDAO;

    public AuthService() {
        this.userDAO = new UserDAO();
        this.roleDAO = new RoleDAO();
    }

    public void bootstrapIfNeeded() {
        Role admin = roleDAO.findByName(ROLE_ADMIN);
        if (admin == null) {
            roleDAO.save(new Role(ROLE_ADMIN));
        }

        Role user = roleDAO.findByName(ROLE_USER);
        if (user == null) {
            roleDAO.save(new Role(ROLE_USER));
        }

        if (userDAO.countAll() == 0) {
            Role adminRole = roleDAO.findByName(ROLE_ADMIN);
            User defaultAdmin = new User("admin", PasswordUtil.sha256("admin"), adminRole);
            userDAO.save(defaultAdmin);
        }
    }

    public User authenticate(String username, String password) {
        if (username == null || username.isBlank() || password == null) {
            return null;
        }
        User u = userDAO.findByUsername(username.trim());
        if (u == null) {
            return null;
        }
        String hash = PasswordUtil.sha256(password);
        if (!hash.equals(u.getPasswordHash())) {
            return null;
        }
        return u;
    }

    public boolean isAdmin(User user) {
        return user != null && user.getRole() != null && ROLE_ADMIN.equalsIgnoreCase(user.getRole().getName());
    }
}

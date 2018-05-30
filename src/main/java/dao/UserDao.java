package dao;

import model.User;
public interface UserDao {
	public User selectUserById(Integer userId);
}

package TestCase;

import org.junit.Test;
import org.springframework.beans.factory.annotation.Autowired;

import model.User;
import service.UserService;
import service.impl.UserServiceImpl;
import test.ServiceTest;

public class UserServiceTest extends ServiceTest{
   @Autowired
 private UserService userService; 

    @Test 
    public void selectUserByIdTest(){  
       User user = userService.selectuser(1);  
        System.out.println(user.getUserName() + ":" + user.getUserPassword());
    }  
}

package com.cmri.bpt.web.restor;

import org.springframework.beans.BeansException;
import org.springframework.context.ApplicationContext;
import org.springframework.context.ApplicationContextAware;
import org.springframework.stereotype.Component;

@Component //@Component 注解 表示这个类是spring的一个组件  
public class SpringBeanUtil implements ApplicationContextAware  
{  
  
    private static ApplicationContext applicationContext;  
      
    public void setApplicationContext(ApplicationContext applicationContext)  
            throws BeansException  
    {  
        SpringBeanUtil.applicationContext = applicationContext;  
    }  
      
    /** 
     * 获取clazz类对应的spring创建的bean对象 
     * @param clazz 
     * @return 
     */  
    public static <T> T getBean(Class<T> clazz)  
    {  
        return (T) applicationContext.getBean(clazz);  
    }  
      
}  
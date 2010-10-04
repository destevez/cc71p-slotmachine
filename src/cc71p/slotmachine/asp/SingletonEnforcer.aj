package cc71p.slotmachine.asp;

import java.util.Hashtable;
import java.util.Map;
/**
 * 
 * Aspecto que implementa singletons
 *
 * 22-09-2010 - (Daniel Estévez G.): versión inicial  
 *
 */
public abstract aspect SingletonEnforcer
{
	declare precedence: SlotMachine;
   Map singletons = new Hashtable();
   abstract pointcut mySingletonClass();
   /**
   * 
   * Pointcut que captura creaciones de singleton
   *
   * 22-09-2010 - (Daniel Estévez G.) - versión inicial
   *
   */
  pointcut selectSingletons():mySingletonClass()&&execution(new(..));
  
  @SuppressWarnings("unchecked")
before() : selectSingletons()
  {
	
     Class<?> singleton = thisJoinPoint.getSignature().getDeclaringType();
     synchronized(singletons)
     {
        if (singletons.get(singleton) == null)
        {
           System.out.println("definido singleton de "+singleton.getSimpleName());
           singletons.put(singleton, singleton);
        }
        else{
        	System.err.println("definido singleton de "+singleton.getSimpleName()+" mas de una vez");
        	System.err.println("definido en "+thisJoinPoint.getSourceLocation());
        	assert(false);
        	System.exit(1);
        }
     }
  }


   
}
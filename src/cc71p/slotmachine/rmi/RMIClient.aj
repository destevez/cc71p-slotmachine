package cc71p.slotmachine.rmi;

import java.io.Serializable;
import java.rmi.Naming;

privileged abstract aspect RMIClient {
	Reciever reciever;	
	String host;
	String port;
	abstract pointcut myInterceptedClass();
	
	void around(Object interceptedClass,Serializable arg):
		myInterceptedClass()
		&& this(interceptedClass)
		&& args(arg)
		&& execution(void *.*(..))
	{	try{
			//System.out.println("interceptado "+thisEnclosingJoinPointStaticPart.getSignature().getName());
			if(reciever!=null)
				reciever.recieve(thisEnclosingJoinPointStaticPart.getSignature().getName(),arg);
			
			proceed(interceptedClass,arg);
		}catch (Exception e) {
			e.printStackTrace();
			
		}
	}
	
	/**
	 * 
	 * Aspecto que captura argumentos del main
	 * ejecuta con el fin de capturar el host y puerto
	 * del servidor RMI
	 *
	 * 03-10-2010 - (Daniel Estévez G.) - versión inicial
	 *
	 * @param args
	 */
	before(String[] args):
		execution(void *.main(..))
		&&args(args)
		&&!within(SlotMachineServer)
		{
		host = args[0];
		port = args[1];
		System.out.println("host-port "+host+"-"+port);
		
		try {
			reciever = (Reciever) Naming.lookup("rmi://"+host+":"+port+"/RMIRemote");
		} catch (Exception e) {
			System.err.println("Could not get a reference to the server.");
			e.printStackTrace();
    	    System.err.println("Quitting, sorry.");
			System.exit(-1);
		};
	}
	

}

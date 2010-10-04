package cc71p.slotmachine.rmi;

import java.rmi.Remote;
import java.rmi.registry.LocateRegistry;
import java.rmi.registry.Registry;
import java.rmi.server.UnicastRemoteObject;

import org.eclipse.swt.widgets.Display;
import org.eclipse.swt.widgets.Shell;

import cc71p.slotmachine.face.Logging;
import cc71p.slotmachine.model.NVRAM;

public class SlotMachineServer {
	static NVRAM nvram;
	/**
	 * @param args
	 */
	public static void main(String[] args) {
    	try {
    		if(args.length != 2){
    			System.out.println("Need 2 arguments:");
    			System.out.println("1. rmi registry address: host ip address");
    			System.out.println("2. rmi registry address: port number");
    			System.exit(1);
    		}
    		nvram = new NVRAM();
    		String host = args[0];
    		int port = Integer.parseInt(args[1]);
    		//Se inicializa UI de logging
    		Display display = new Display();
    		Shell shellLogging = new Shell(display);
    		
    		Logging ui = new Logging(shellLogging,false);
    		
            // Create and register the HelloRegister.
    		Registry registry = LocateRegistry.getRegistry(host, port);

    		//Make the printer object
    		Reciever prn = new RecieverImpl(ui);
    		
    		//Make the object RMI call-able
	    	Object stub = UnicastRemoteObject.exportObject((Remote) prn, 0);
	    	
	    	//Allow clients to connect to the object
	    	registry.rebind("RMIRemote", (Remote) stub);
	    	
    	    System.out.println("RMIRemote server ready");
    	    shellLogging.open();
    	    while (!shellLogging.isDisposed()) {
    			if (!display.readAndDispatch ()) display.sleep ();
    		}
    		display.dispose ();	
    	} catch (Exception e) {
    	    System.err.println("RMIRemote server exception: " + e.toString());
    	    e.printStackTrace();
    	    System.err.println("Server quitting, sorry.");
    	    System.exit(1);
    	}
    	
    	
    }

}

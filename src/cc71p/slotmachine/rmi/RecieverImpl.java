package cc71p.slotmachine.rmi;

import java.io.Serializable;
import java.lang.reflect.Method;
import java.rmi.Remote;
import java.rmi.RemoteException;

import cc71p.slotmachine.face.Logging;

public class RecieverImpl implements Remote,Reciever{
	Logging ui;
	public RecieverImpl(Logging ui) {
		this.ui=ui;
	}
	@Override
	public void recieve(String methodName, Serializable arg) throws RemoteException{
		System.out.println("Se ejecuta en servidor "+methodName+"-"+arg);
		Class<?> cls = ui.getClass();
		try{
			Method meth = cls.getMethod(methodName, arg.getClass());
			//System.out.println(meth.invoke(ui, arg));
			meth.invoke(ui, arg);
		}catch (Exception e) {
			e.printStackTrace();
		}
		
	}
}

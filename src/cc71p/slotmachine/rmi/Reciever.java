package cc71p.slotmachine.rmi;

import java.io.Serializable;
import java.rmi.Remote;
import java.rmi.RemoteException;

public interface Reciever extends Remote{
	public void recieve(String methodName,Serializable arg) throws RemoteException;
}

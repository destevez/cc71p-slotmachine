package cc71p.slotmachine.rmi;
import cc71p.slotmachine.face.Logging;
public aspect SlotMachineClients extends RMIClient{
	pointcut myInterceptedClass():
		within(Logging);	
}

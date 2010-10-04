package cc71p.slotmachine.asp;

import cc71p.slotmachine.model.BillAcceptor;
import cc71p.slotmachine.model.CoinHopper;
import cc71p.slotmachine.model.Enclosure;
import cc71p.slotmachine.model.NVRAM;
/**
 * 
 * <b>Aspecto que implementa singletons de clases que deben implementar
 * el patron</b>
 * 
 *
 * 03-10-2010 - (Daniel Estévez G.): versión inicial  
 *
 */
public aspect SlotMachineSingletons extends SingletonEnforcer{
	pointcut mySingletonClass():
		within(BillAcceptor) ||
		within(CoinHopper) ||
		within(Enclosure) ||
		within(NVRAM);
}

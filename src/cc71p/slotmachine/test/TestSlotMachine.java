package cc71p.slotmachine.test;

import junit.framework.Assert;

import org.junit.Before;
import org.junit.Test;

import cc71p.slotmachine.asp.SlotMachine;
import cc71p.slotmachine.face.InterfazHardware;
import cc71p.slotmachine.face.InterfazUsuario;
import cc71p.slotmachine.model.Reel;

/**
 * Contiene los JUnit Test de la Slot Machine
 * 
 * @author daniel
 *
 */
public class TestSlotMachine {
	
	/*private SlotMachine sM;
	private InterfazHardware iH;
	private InterfazUsuario iU;
	@Before 
	public void setUp(){
		sM= new SlotMachine();
		iH= sM.iH;
		iU = sM.iU;
	}
	@Test
	public void testInputCredits(){
		int creditosB =sM.credits;
		int credits = 30;
		iH.insert(credits);
		Assert.assertEquals(credits+creditosB, sM.credits);
	}
	
	@Test
	public void testCanPlay(){
		String resultado1="";
		for(Reel r:sM.reels){
			resultado1+=""+r.value;
		}
		iU.play();
		String resultado2="";
		for(Reel r:sM.reels){
			resultado2+=""+r.value;
		}
		Assert.assertNotSame(resultado1, resultado2);
	}
	@Test
	public void testCanLockAndUnLock(){
		iU.canLock=true;
		for(int i=0;i<5;i++){
			iU.lock(i);
			Assert.assertEquals(true, sM.reels[i].locked);
			sM.reels[i].unlock();
			Assert.assertEquals(false, sM.reels[i].locked);
		}		
	}
	@Test
	public void testGetMoney(){
		iH.get();
		Assert.assertEquals(sM.coinHopper.totalAmount, 0);
	}
	/**
	 * Test that play XOR insert money happens
	 */
	/*@Test
	public void testFlowControl(){
		/**
		 * Note: at this point the SlotMachine is playing
		 */
		/*sM.playing=true;
		int creditB = sM.credits;
		/**
		 * Nothing happens..
		 */
		/*iH.insert(400);
		int creditA = sM.credits;
		Assert.assertEquals(creditB, creditA);
		while(sM.playing){
			iU.play();
		}
		creditB = sM.credits;
		/**
		 * Now it happens..
		 */
		/*iH.insert(400);
		creditA = sM.credits;
		System.out.println(creditB+ " "+creditA);
		Assert.assertNotSame(creditB, creditA);
		
	}
	
	@Test
	public void testCanPlayWith5(){
		/**
		 * We empty the credits
		 */
		/*while(sM.playing){
			iU.play();
		}
		
		String resultado1="";
		for(Reel r:sM.reels){
			resultado1+=""+r.value;
		}
		/**
		 * Nothing happens...
		 */
		/*iU.play();
		String resultado2="";
		for(Reel r:sM.reels){
			resultado2+=""+r.value;
		}
		Assert.assertEquals(resultado1, resultado2);
	}*/
	
}

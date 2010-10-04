package cc71p.slotmachine.asp;

import java.io.Serializable;
import java.lang.reflect.Field;
import java.util.List;
import java.util.concurrent.CopyOnWriteArrayList;

import cc71p.slotmachine.model.BillAcceptor;
import cc71p.slotmachine.model.CoinHopper;
import cc71p.slotmachine.model.Enclosure;
import cc71p.slotmachine.model.NVRAM;
import cc71p.slotmachine.model.Reel;
/**
 * 
 * <b>Aspecto que implementa persistencia de la slot machine sobre cortes de luz</b>
 * 
 *	Por convención se almacenaran los modelos locales de slot machine, lo ideal
 *sería capturar además los modelos de la ui, pero SWT no me permite aplicar
 *serialización de sus clases, tema que falta investigar...
 *		- 
 *
 * 23-09-2010 - (Daniel Estévez G.): versión inicial  
 *
 */
privileged aspect Persistency {
	declare parents: cc71p.slotmachine.model.* implements Serializable;
	declare parents: cc71p.slotmachine.face.* implements Serializable;
/**
 * No aplica a jar compilado por lo que hay que trabajar fuentes de SWT para poder
 * agregar UIs a NVRAM
 */
	declare parents: org.eclipse.swt.widgets.* implements Serializable;
	NVRAM ram;
	boolean recuperado;
	boolean maquinaEncendida;
	SlotMachine sM;
	static List<String> fieldsIgnored;
	static{
		fieldsIgnored = new CopyOnWriteArrayList<String>();
		fieldsIgnored.add("maquinaEncendida");
		fieldsIgnored.add("nvram");
		fieldsIgnored.add("ajc$initFailureCause");
		fieldsIgnored.add("ajc$perSingletonInstance");
		fieldsIgnored.add("shelliH");
		fieldsIgnored.add("shelliU");
		fieldsIgnored.add("shellDebug");
		fieldsIgnored.add("shellMeters");
		fieldsIgnored.add("shellEnclosure");
		fieldsIgnored.add("shellRecall");
		fieldsIgnored.add("shellDemo");
		fieldsIgnored.add("shellLogging");
		fieldsIgnored.add("iH");
		fieldsIgnored.add("iU");
		fieldsIgnored.add("display");
		fieldsIgnored.add("demoUI");
		fieldsIgnored.add("debugUI");
		fieldsIgnored.add("metersUI");
		fieldsIgnored.add("enclosureUI");
		fieldsIgnored.add("recallUI");
		fieldsIgnored.add("loggingUI");
	}
	/**
	 * 
	 * Aspecto que camputa a la maquina encendida y a la slotmachine
	 *
	 * 03-10-2010 - (Daniel Estévez G.) - versión inicial
	 *
	 * @param sM slot machine
	 * @param mE boolean que indica maquina encendida
	 */
	after(SlotMachine sM, boolean mE):
		target(sM)&&args(mE)&&set(boolean SlotMachine.maquinaEncendida){
		this.sM=sM;
		this.maquinaEncendida=mE;
		
		if(!mE){
			ram._ram.clear();
			ram.doSave();
		}
		else{
			/**
			 * Se recuperan valores de RAM estatica si existen
			 */
			/**
			 * Reflective no aplica aspectos!!
			 */
			/*for(Field f:SlotMachine.class.getDeclaredFields()){
				System.out.println("Buscando para recuperar "+f.getName());
				if(fieldsIgnored.contains(f.getName())
						||ram._ram.get(f.getName())==null)
					continue;
				System.out.println("se recupera set de "+f.getName()+" con valor "+ram._ram.get(f.getName()));
				try{
					f.set(sM, ram._ram.get(f.getName()));
				}
				catch (Exception e) {
					e.printStackTrace();
				}
			}*/
			/**
			 * Se hace de forma manual
			 */
			if(ram._ram.get("credits")!=null)
				sM.credits = (Integer)ram._ram.get("credits");
			if(ram._ram.get("MIN_CREDITS")!=null)
				sM.MIN_CREDITS = (Integer)ram._ram.get("MIN_CREDITS");
			if(ram._ram.get("reelAmount")!=null)
				sM.reelAmount = (Integer)ram._ram.get("reelAmount");
			if(ram._ram.get("playing")!=null)
				sM.playing = (Boolean)ram._ram.get("playing");
			if(ram._ram.get("playSecondTime")!=null)
				sM.playSecondTime = (Boolean)ram._ram.get("playSecondTime");
			if(ram._ram.get("creditsInserted")!=null)
				sM.creditsInserted = (Integer)ram._ram.get("creditsInserted");
			if(ram._ram.get("nReelsLocked")!=null)
				sM.nReelsLocked = (Integer)ram._ram.get("nReelsLocked");
			if(ram._ram.get("reels")!=null)
				sM.reels = (Reel[])ram._ram.get("reels");
			if(ram._ram.get("reelsLocked")!=null)
				sM.reelsLocked = (boolean[])ram._ram.get("reelsLocked");
			if(ram._ram.get("billAcceptor")!=null)
				sM.billAcceptor = (BillAcceptor)ram._ram.get("billAcceptor");
			if(ram._ram.get("coinHopper")!=null)
				sM.coinHopper = (CoinHopper)ram._ram.get("coinHopper");
			if(ram._ram.get("enclosure")!=null)
				sM.enclosure = (Enclosure)ram._ram.get("enclosure");
			if(ram._ram.get("DEMO")!=null)
				sM.DEMO = (Boolean)ram._ram.get("DEMO");
			
			
			
			this.recuperado=true;
		}
	}
	/**
	 * 
	 * Aspecto que captura nvram en el aspecto y lo inicializa
	 *
	 * 23-09-2010 - (Daniel Estévez G.) - versión inicial
	 *
	 * @param ui
	 */
	after(NVRAM ram):this(ram)&&execution(NVRAM+.new(..)){
		this.ram=ram;
		ram.doLoad();
	}
	

	
	/**
	 * 
	 * Aspecto que restaura slot machine luego de encendido
	 *
	 * 28-09-2010 - (Daniel Estévez G.) - versión inicial
	 *
	 */
	
	after():
		set(* SlotMachine.*)
	{
		if(!this.maquinaEncendida||!this.recuperado)
			return;
		System.out.println("se captura slot machine en ram estatica");
		
		for(Field f:SlotMachine.class.getDeclaredFields()){
			if(fieldsIgnored.contains(f.getName()))					
				continue;
			try{
				System.out.println("Set de "+f.getName()+" con valor "+f.get(sM));
				ram._ram.put(f.getName(), f.get(sM));
			}catch (Exception e) {
				e.printStackTrace();
			}
		}
		ram.doSave();
	}
	
	
	
	
}

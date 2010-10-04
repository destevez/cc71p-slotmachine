package cc71p.slotmachine.asp;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import org.eclipse.swt.widgets.Button;

import cc71p.slotmachine.face.InterfazHardware;
import cc71p.slotmachine.face.InterfazUsuario;
import cc71p.slotmachine.face.UIEnclosure;
import cc71p.slotmachine.model.Cerradura;
import cc71p.slotmachine.model.CoinHopper;
import cc71p.slotmachine.model.Enclosure;
import cc71p.slotmachine.model.Lampara;


/**
 * 
 * <b>Aspecto que implementa funcionalidad de enclosure y comportamiento frente a fallas</b>
 * 
 *
 * 03-10-2010 - (Daniel Estévez G.): versión inicial  
 *
 */
public aspect TamperProof {	
	InterfazHardware iH;
	InterfazUsuario iU;
	SlotMachine sM;
	CoinHopper cH;
	UIEnclosure ui;
	List<Boolean> condicionPreviaLocks;
	Cerradura cerraduraPrevia;
	boolean enclosureAbierto;
	public TamperProof() {
		condicionPreviaLocks= new ArrayList<Boolean>();
		enclosureAbierto=false;
	}
	
	/** 
	 * Advice que captura la slot machine
	 */
	after(SlotMachine sM):this(sM)&&execution(SlotMachine+.new(..)){
		this.sM=sM;
	}
	
	/** 
	 * Advice que captura la interfaz de hardware
	 */
	after(CoinHopper cH):this(cH)&&execution(CoinHopper+.new(..)){
		this.cH=cH;
	}
	/** 
	 * Advice que captura la interfaz de hardware
	 */
	after(InterfazHardware iH):this(iH)&&execution(InterfazHardware+.new(..)){
		this.iH=iH;
	}
	
	/** 
	 * Advice que captura la interfaz de hardware
	 */
	after(InterfazHardware iH):this(iH)&&execution(InterfazHardware+.new(..)){
		this.iH=iH;
	}
	
	/** 
	 * Advice que captura la interfaz de usuario
	 */
	after(InterfazUsuario iU):this(iU)&&execution(InterfazUsuario+.new(..)){
		this.iU=iU;
	}
	
	/** 
	 * Advice que captura la ui de enclosure
	 */
	after(UIEnclosure ui):this(ui)&&execution(UIEnclosure+.new(..)){
		this.ui=ui;
		ui.printDialogBox("iniciado dialog box..");
	}
	/**
	 * 
	 * DMétodo que detiene el juego y enciende la lampara en caso de abrir
	 * enclosure
	 *
	 * 22-09-2010 - (Daniel Estévez G.) - versión inicial
	 *
	 * @param e
	 */
	after(Enclosure e):target(e)&& set(boolean Enclosure.open){
		if(e.open){
			detenerJuego();
			e.lampara=Lampara.ENCENDIDA;
			ui.labelLampara.setText("Encendida");
			enclosureAbierto=true;
			ui.printDialogBox("se abre enclosure");
		}
		else{
			enclosureAbierto=false;
			if(ui!=null)
				ui.printDialogBox("se cierra enclosure");
		}
	}
	
	
	
	/**
	 * 
	 * Captura posicion previa a movimiento de cerradura
	 *
	 * 22-09-2010 - (Daniel Estévez G.) - versión inicial
	 *
	 * @param e
	 */
	before(Enclosure e):target(e)&&set(Cerradura Enclosure.cerradura){
		cerraduraPrevia=e.cerradura;
		if(ui!=null)
			ui.printDialogBox("se detecta posicion previa llave "+e.cerradura);
	}
	/**
	 * 
	 * Advice que continua juego en caso de estar cerrado enclosure y hacer
	 * movimiento de llave correcto
	 *
	 * 22-09-2010 - (Daniel Estévez G.) - versión inicial
	 *
	 * @param e
	 */
	after(Enclosure e):target(e)&&set(Cerradura Enclosure.cerradura){
		if(cerraduraPrevia==Cerradura.INICIAL&&!enclosureAbierto){
			if(e.cerradura==Cerradura.TODO_BIEN){
				e.lampara=Lampara.APAGADA;
				ui.labelLampara.setText("Apagada");
				continuarJuego();
				ui.printDialogBox("se continua juego "+e.cerradura);
			}
			else if(e.cerradura==Cerradura.PAYBACK&&!demoSm){
				ui.printDialogBox("se hace payback de juego "+e.cerradura);
				e.lampara=Lampara.APAGADA;
				ui.labelLampara.setText("Apagada");
				continuarJuegoPayback();
				
			}
		}
	}
	
	/**
	 * 
	 * Método que detiene el juego en función de bloquear los botones
	 * de las interfaces de usuarios y hardware
	 *
	 * 21-09-2010 - (Daniel Estévez G.) - versión inicial
	 *
	 */
	boolean demoSm=false;
	void detenerJuego(){
		
		//Se bloquean botones
		condicionPreviaLocks.clear();
		condicionPreviaLocks.add(iU.buttonPlay.isEnabled());
		iU.buttonPlay.setEnabled(false);
		for(Button b:iU.buttons){
			condicionPreviaLocks.add(b.isEnabled());
			b.setEnabled(false);
		}
		condicionPreviaLocks.add(iH.demo.isEnabled());
		iH.demo.setEnabled(false);
		condicionPreviaLocks.add(iH.fail.isEnabled());
		iH.fail.setEnabled(false);
		condicionPreviaLocks.add(iH.get.isEnabled());
		iH.get.setEnabled(false);
		condicionPreviaLocks.add(iH.insert.isEnabled());
		iH.insert.setEnabled(false);
		condicionPreviaLocks.add(iH.textInsert.isEnabled());
		iH.textInsert.setEnabled(false);
		
	}
	/**
	 * 
	 * Continua juego en funcion de condicion previa
	 *
	 * 22-09-2010 - (Daniel Estévez G.) - versión inicial
	 *
	 */
	void continuarJuego(){
		//Se desbloquean botones
		Iterator<Boolean> it = condicionPreviaLocks.iterator();
		iU.buttonPlay.setEnabled(it.next());
		
		for(Button b:iU.buttons){
			b.setEnabled(it.next());
		}
		iH.demo.setEnabled(it.next());
		iH.fail.setEnabled(it.next());
		iH.get.setEnabled(it.next());
		iH.insert.setEnabled(it.next());
		iH.textInsert.setEnabled(it.next());
		
	}
	
	/**
	 * 
	 * Continua juego en funcion de condicion previa
	 *
	 * 22-09-2010 - (Daniel Estévez G.) - versión inicial
	 *
	 */
	void continuarJuegoPayback(){
		cH.payout(sM.credits);
		sM.credits=0;
		//Se desbloquean botones		
		iU.buttonPlay.setEnabled(true);
		
		for(Button b:iU.buttons){
			b.setEnabled(false);
		}
		iH.demo.setEnabled(true);
		iH.fail.setEnabled(true);
		iH.get.setEnabled(true);
		iH.insert.setEnabled(true);
		iH.textInsert.setEnabled(true);
	}
	
	
	/**
	 * Advice que captura toda la información de errores del dialog box de 
	 * la interfaz de hardware y la redirige a la propia UI
	 * 
	 */
	after(InterfazHardware iH, String s):target(iH)&&
		args(s)&&call(void InterfazHardware.fail(..))
	{
		if(ui!=null)
			ui.printDialogBox("Se detiene juego por falla de hardware "+s);
		detenerJuego();
	};
	
}

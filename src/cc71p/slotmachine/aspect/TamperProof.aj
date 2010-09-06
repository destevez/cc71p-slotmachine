package cc71p.slotmachine.aspect;

import cc71p.slotmachine.BillAcceptor;
import cc71p.slotmachine.Cerradura;
import cc71p.slotmachine.CoinHopper;
import cc71p.slotmachine.Enclosure;
import cc71p.slotmachine.Lampara;
import cc71p.slotmachine.SlotMachine;
import cc71p.slotmachine.face.InterfazHardware;


public aspect TamperProof {	
	private SlotMachine sM;
	/**
	 * Valores de juego previos a detención
	 */
	private boolean canPlay,canLock, cerraduraEnInicial, juegoDetenido;
	public TamperProof() {
		canPlay=true;
		canLock=true;
		cerraduraEnInicial=true;
		juegoDetenido=false;
	}
	
	/**
	 * UI simple de aspecto tamper-proof
	 * 
	 * s texto a imprimir en la UI
	 */
	private void printUITamperProof(String s){
		System.out.println("++++++++++++TAMPER-PROOF+++++++++++++++++");
		System.out.println(s);
		System.out.println("+++++++++++++++++++++++++++++++++++++++++");
	}
	
	/**
	 * 
	 * Advice que captura slot machine luego de que esta es creada
	 * 
	 * @param sM slot machine que crea slot machine
	 * @param e Enclosure de la slot machine
	 */
	before(SlotMachine sM) :this(sM)&&execution(SlotMachine+.new(..)) {
		       this.sM = sM;
		       this.printUITamperProof("Capturada Slot Machine en aspecto");
	}
	
	
	
	/**
	 * Advice que detecta cuando un enclosure se abre deteniendo el juego si es que no lo esta ya
	 * 
	 * @param e enclosure abierto
	 */
	after(Enclosure e):target(e)&&set(boolean Enclosure.open)&&if(e.open){
		if(this.juegoDetenido)
			return;
		this.printUITamperProof("Abierto enclosure. Se detiene el juego");
		detieneJuego();
		
		
	}	
	
	/**
	 * Advice que captura si es que se gira cerradura a todo bien con juego detenido cosa de continuarlo.
	 * Enclosure debe estar cerrado
	 * 
	 * @param e Enclosure que se cierra
	 */
	after(Enclosure e):target(e)&&set(Cerradura Enclosure.cerradura)&&if(!e.open&&e.cerradura==Cerradura.TODO_BIEN)
		{
			if(!this.juegoDetenido||!this.cerraduraEnInicial)
				return;
			this.printUITamperProof("Enclosure esta cerrado y se cierra llave como todo bien desde posicion inicial por lo que se continua el juego");
			/**
			 * Se restaura el juego y continua
			 */
			this.sM.iU.canLock=this.canLock;
			this.sM.iU.canPlay=this.canPlay;
			this.juegoDetenido=false;
			e.lampara=Lampara.APAGADA;
	}
	
	/**
	 * Advice que captura si es que se gira cerradura a payback con juego detenido cosa de finalizar el juego
	 * y entregar el dinero de credits
	 * Enclosure debe estar cerrado
	 * 
	 * @param e Enclosure que se cierra
	 */
	after(Enclosure e):target(e)&&set(Cerradura Enclosure.cerradura)&&if(!e.open&&e.cerradura==Cerradura.PAYBACK)
		{
			if(!this.juegoDetenido||!this.cerraduraEnInicial)
				return;
			this.printUITamperProof("Enclosure esta cerrado y se cierra llave como payback desde posicion inicial, por lo que se finaliza el juego y entrega dinero");
			/**
			 * Se finaliza juego y se entregan credits
			 */
			this.sM.iU.canLock=false;
			this.sM.iU.canPlay=true;
			this.juegoDetenido=false;
			this.sM.coinHopper.payout(sM.credits);
			this.sM.credits=0;
			this.sM.playing=false;
			e.lampara=Lampara.APAGADA;
	}
	/**
	 * Pointcut que captura llamadas a métodos de bill acceptor
	 * @param bA bill acceptor
	 */	
	pointcut billAcceptorMethod(BillAcceptor bA):
		target(bA)&& call(* BillAcceptor.*(..));
	/**
	 * Pointcut que captura llamadas a métodos de coin hopper
	 * @param cH coin hopper
	 */	
	pointcut coinHopperMethod(CoinHopper cH):
		target(cH)&& call(* CoinHopper.*(..));
	/**
	 * Pointvut que captura llamadas a método fail de Interfaz de Hardware
	 * @param iH
	 */
	pointcut iHFail(InterfazHardware iH):
		target(iH)&&call(void InterfazHardware.fail(String));
			
	/**
	 * Advice que detiene juego en caso de haber falla en bill acceptor
	 * @param bA bill acceptor
	 */
	before(BillAcceptor bA,InterfazHardware iH): 
				cflow(billAcceptorMethod(bA))&&iHFail(iH){	
		if(this.juegoDetenido)
			return;
		this.printUITamperProof("Falla en bill acceptor. Se detiene juego");
		this.juegoDetenido=true;
		detieneJuego();
				
	}
	
	/**
	 * Advice que detiene juego en caso de haber falla en coin hopper
	 * @param cH coin hopper
	 */
	before(CoinHopper cH,InterfazHardware iH): 
				cflow(coinHopperMethod(cH))&&iHFail(iH){		
		if(this.juegoDetenido)
			return;
		this.printUITamperProof("Falla en coin hopper. Se detiene juego");
		detieneJuego();
	}
	
	/**
	 * Advice que captura posicion de cerradura justo antes de efectuar un cambio en esta
	 * 
	 * @param e Enclosure del cual se captura posicion de cerradura
	 */
	before(Enclosure e):target(e)&&set(Cerradura Enclosure.cerradura)
		{
			if(e.cerradura==Cerradura.INICIAL)
				this.cerraduraEnInicial=true;
			else
				this.cerraduraEnInicial=false;
			
			this.printUITamperProof("Cerradura esta en inicial antes de cambio "+this.cerraduraEnInicial);
	}
	
	
	private void detieneJuego(){
		/**
		 * Almacena los valores previos y detiene el juego
		 */
		this.canLock=this.sM.iU.canLock;
		this.canPlay=this.sM.iU.canPlay;
		this.sM.iU.canLock=false;
		this.sM.iU.canPlay=false;
		this.sM.enclosure.lampara=Lampara.ENCENDIDA;
		this.juegoDetenido=true;
	}
	
	
	
}

package cc71p.slotmachine.asp;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.ListIterator;

import org.eclipse.swt.widgets.Display;

import cc71p.slotmachine.face.InterfazHardware;
import cc71p.slotmachine.face.InterfazUsuario;
import cc71p.slotmachine.face.UIMeters;
import cc71p.slotmachine.model.BillAcceptor;
import cc71p.slotmachine.model.CoinHopper;
import cc71p.slotmachine.model.PayTable;
import cc71p.slotmachine.model.Reel;
/**
 * Aspecto que se encarga de llevar los meters del juego, cuenta con su propia UI definida en el método
 * printUIMeters(String)
 * 
 * @author daniel
 *
 */
public aspect Meters {
	UIMeters ui;
	SlotMachine sM;
	int reelAmount, cantidadReelCongelados=0;
	boolean DEMO;
	
	/** 
	 * Advice que captura el UI del aspecto Demo
	 */
	after(UIMeters ui):this(ui)&&execution(UIMeters+.new(..)){
		this.ui=ui;
		ui.printDialogBox("iniciado dialog box..");
	}
	
	/** 
	 * Advice que captura el UI del aspecto Demo
	 */
	after(SlotMachine sM):this(sM)&&execution(SlotMachine+.new(..)){
		this.sM=sM;
		reelAmount=sM.reelAmount;
	}
	/**
	 * 
	 * Advice que captura cambios en el parametro demo de la slot machine
	 *
	 * 21-09-2010 - (Daniel Estévez G.) - versión inicial
	 *
	 * @param sM
	 */
	after(SlotMachine sM):
		this(sM)&&set(boolean SlotMachine.DEMO){
		DEMO=sM.DEMO;		
		countLock=0;
	}
	
	private int totalDineroInsertado=0, totalDineroPagado=0,ultimoMontoDineroInsertado=0;
	private Date fechaHoraUltimoMontoDineroInsertado=null;
	private int ultimoPayOut=0;
	private Date fechaHoraUltimoPayOut=null;
	private Date fechaHoraUltimoJuego=null;
	private List<Reel> ultimoJuego= new ArrayList<Reel>();
	private int ultimoValorGanado=0;
	
	private List<String> tipoUltimoError=new ArrayList<String>();
	private List<Date> fechaUltimoError=new ArrayList<Date>();
	
	
	/**
	 * Método que representa el imprimir texto en la UI independiente del aspecto
	 * Meters
	 * 
	 * @param s texto a imprimir
	 */
	private final void printUIMeters(){
		ui.printDialogBox("++++++++++++++++++++++++++++++++++");
		ui.printDialogBox("   ***********************************************************************");
		ListIterator<String> itTipos = tipoUltimoError.listIterator(tipoUltimoError.size());
		ListIterator<Date> itFechas = fechaUltimoError.listIterator(fechaUltimoError.size());
		while(itTipos.hasPrevious()){
			String tipoError = itTipos.previous();
			Date fechaError = itFechas.previous();
		    ui.printDialogBox("             Error [fecha y hora, tipo]    : ["+tipoError+","+fechaError+"]");
		}
		
		
		ui.printDialogBox("   *******************************ERRORES*********************************");
		ui.printDialogBox("   ***********************************************************************");
		ui.printDialogBox("             Valor ganado                 : "+ultimoValorGanado);
		ui.printDialogBox("             Cantidad de reels congelados : "+cantidadReelCongelados);
		
		for (int i=ultimoJuego.size()-1;i>0;i--){
			Reel reel = ultimoJuego.get(i);
			ui.printDialogBox("             Reel [numero,resultado]      : ["+i+","+reel.value+"]");
		}
		ui.printDialogBox("             Fecha y hora               : "+fechaHoraUltimoJuego);
		ui.printDialogBox("   *******************************ULTIMO JUEGO****************************");
		
		ui.printDialogBox("    Fecha hora ultimo payout                            : "+fechaHoraUltimoPayOut);
		ui.printDialogBox("    Monto ultimo payout                                 : "+ultimoPayOut);
		ui.printDialogBox("    Fecha y hora ultimo monto de dinero insertado       : "+fechaHoraUltimoMontoDineroInsertado);
		ui.printDialogBox("    Ultimo monto de dinero insertado                    : "+ultimoMontoDineroInsertado);
		ui.printDialogBox("    Total dinero pagado desde encendido                 : "+totalDineroPagado);
		ui.printDialogBox("    Total dinero ingresado desde encendido              : "+totalDineroInsertado);
		ui.printDialogBox("++++++++++++METERS+++++++++++++++++");		
	}
	
	
	
	/**
	 * 
	 * Advice que captura el ultimo monto de dinero insertado más su fecha y hora
	 * 
	 * @param bA Bill acceptor que captura dinero
	 * @param iH interfaz de hardware
	 */
	after(BillAcceptor bA) returning (int amount): call (int BillAcceptor.detect())
		  && target(bA){
		if(DEMO)
			return;
		       this.fechaHoraUltimoMontoDineroInsertado=Calendar.getInstance().getTime();
		       this.ultimoMontoDineroInsertado=amount;
		       this.totalDineroInsertado+=amount;
		     
	}
	
	/**
	 * 
	 * Advice que captura el ultimo payout más su fecha y hora
	 * 
	 * @param cH Coin hopper que hace payout
	 * @param amount cantidad de payout
	 */
	after(CoinHopper cH, int amount): call (void CoinHopper.payout(int))
		  && target(cH)&&args(amount){
		if(DEMO)
			return;
		       this.fechaHoraUltimoPayOut=Calendar.getInstance().getTime();
		       this.ultimoPayOut=amount;
		       this.totalDineroPagado+=amount;
	}
	/**
	 * Advice que captura información del ultimo juego
	 * 
	 * @param iU Interfaz de Usuario
	 */
	after(InterfazUsuario iU): target(iU) &&call(void InterfazUsuario.play()){
		if(DEMO)
			return;
		this.fechaHoraUltimoJuego=Calendar.getInstance().getTime();
		Reel[] reels = sM.reels;
		this.ultimoJuego.clear();
		for(Reel r:reels){
			this.ultimoJuego.add(r);
		}
		this.ultimoValorGanado=PayTable.payout(reels);
	}
	/**
	 * Advice que se encarga de contabilizar los errores ocurridos desde el encendido
	 * @param iH interfaz de hardware
	 * @param tipo tipo de error
	 */
	after(InterfazHardware iH, String tipo): call(void InterfazHardware.fail(String)) 
	&&target(iH) &&args(tipo){
		if(DEMO)
			return;
		this.fechaUltimoError.add(Calendar.getInstance().getTime());
		this.tipoUltimoError.add(tipo);
	}
	int countLock=0;
	/**
	 * 
	 * DAdvice que contabiliza locks de reels para el cálculo
	 * de reels congelados en el ultimo juego
	 *
	 * 21-09-2010 - (Daniel Estévez G.) - versión inicial
	 *
	 * @param iU
	 * @param index
	 */
	after(InterfazUsuario iU,int index):target(iU)&&args(index)
	&&call(void InterfazUsuario.lock(int)){
		if(DEMO)
			return;
		countLock++;
	}
	/**
	 * 
	 * Advice que determina el numero de reels congelados en el 
	 * ultimo juego antes de comenzar uno nuevo
	 *
	 * 21-09-2010 - (Daniel Estévez G.) - versión inicial
	 *
	 */
	before():call(void InterfazUsuario.play(..)){
		if(DEMO)
			return;
		cantidadReelCongelados=countLock;
		countLock=0;
	}
	
	
	after():call(UIMeters+.new(..)){
		ui.printDialogBox("Se muestran Meters cada 5 segundos...");
		Display.getCurrent().timerExec(5000, muestraMeters());		
	}
	
	Thread muestraMeters(){
		Thread t = new Thread(){
			@Override
			public void run() {
				printUIMeters();
				Thread aux=muestraMeters();
				Display.getCurrent().timerExec(5000, aux);
			}
		};
		return t;
	}
	
	
}

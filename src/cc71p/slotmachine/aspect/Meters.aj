package cc71p.slotmachine.aspect;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.Iterator;
import java.util.List;

import cc71p.slotmachine.BillAcceptor;
import cc71p.slotmachine.CoinHopper;
import cc71p.slotmachine.PayTable;
import cc71p.slotmachine.Reel;
import cc71p.slotmachine.face.InterfazHardware;
import cc71p.slotmachine.face.InterfazUsuario;
/**
 * Aspecto que se encarga de llevar los meters del juego, cuenta con su propia UI definida en el método
 * printUIMeters(String)
 * 
 * @author daniel
 *
 */
public aspect Meters {
	/**
	 * Método que representa el imprimir texto en la UI independiente del aspecto
	 * Meters
	 * 
	 * @param s texto a imprimir
	 */
	private void printUIMeters(){
		System.out.println("++++++++++++METERS+++++++++++++++++");
		System.out.println("    Total dinero ingresado desde encendido              : "+totalDineroInsertado);
		System.out.println("    Total dinero pagado desde encendido                 : "+totalDineroPagado);
		System.out.println("    Ultimo monto de dinero insertado                    : "+ultimoMontoDineroInsertado);
		System.out.println("    Fecha y hora ultimo monto de dinero insertado       : "+fechaHoraUltimoMontoDineroInsertado);
		System.out.println("    Monto ultimo payout                                 : "+ultimoPayOut);
		System.out.println("    Fecha hora ultimo payout                            : "+fechaHoraUltimoPayOut);
		System.out.println("   *******************************ULTIMO JUEGO****************************");
		System.out.println("             Fecha y hora               : "+fechaHoraUltimoJuego);
		int cantidadReelCongelados=0,i=0;
		for (Reel reel:ultimoJuego){
			if(reel.locked==true)
				cantidadReelCongelados++;
		System.out.println("             Reel [numero,resultado]      : ["+i+","+reel.value+"]");
			i++;
		}
		System.out.println("             Cantidad de reels congelados : "+cantidadReelCongelados);
		System.out.println("             Valor ganado                 : "+ultimoValorGanado);
		
		System.out.println("   ***********************************************************************");
		System.out.println("   *******************************ERRORES*********************************");
		Iterator<String> itTipos = tipoUltimoError.iterator();
		Iterator<Date> itFechas = fechaUltimoError.iterator();
		while(itTipos.hasNext()){
			String tipoError = itTipos.next();
			Date fechaError = itFechas.next();
		System.out.println("             Error [fecha y hora, tipo]    : ["+tipoError+","+fechaError+"]");
		}
		System.out.println("   ***********************************************************************");
		System.out.println("++++++++++++++++++++++++++++++++++");
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
	 * 
	 * Advice que captura el ultimo monto de dinero insertado más su fecha y hora
	 * 
	 * @param bA Bill acceptor que captura dinero
	 * @param iH interfaz de hardware
	 */
	after(BillAcceptor bA) returning (int amount): call (int BillAcceptor.detect())
		  && target(bA){
		       this.fechaHoraUltimoMontoDineroInsertado=Calendar.getInstance().getTime();
		       this.ultimoMontoDineroInsertado=amount;
		       this.totalDineroInsertado+=amount;
		       this.printUIMeters();
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
		       this.fechaHoraUltimoPayOut=Calendar.getInstance().getTime();
		       this.ultimoPayOut=amount;
		       this.totalDineroPagado+=amount;
		       this.printUIMeters();
	}
	/**
	 * Advice que captura información del ultimo juego
	 * 
	 * @param iU Interfaz de Usuario
	 */
	after(InterfazUsuario iU): target(iU) &&call(void InterfazUsuario.play()) &&if(iU.canPlay){
		this.fechaHoraUltimoJuego=Calendar.getInstance().getTime();
		Reel[] reels = iU.sM.reels;
		this.ultimoJuego.clear();
		for(Reel r:reels){
			this.ultimoJuego.add(r);
		}
		this.ultimoValorGanado=PayTable.payout(reels);
		this.printUIMeters();
	}
	/**
	 * Advice que se encarga de contabilizar los errores ocurridos desde el encendido
	 * @param iH interfaz de hardware
	 * @param tipo tipo de error
	 */
	after(InterfazHardware iH, String tipo): call(void InterfazHardware.fail(String)) 
	&&target(iH) &&args(tipo){
		this.fechaUltimoError.add(Calendar.getInstance().getTime());
		this.tipoUltimoError.add(tipo);
		this.printUIMeters();
	}
	
	
	
	
}

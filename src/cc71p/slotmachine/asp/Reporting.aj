package cc71p.slotmachine.asp;

import java.util.Enumeration;

import org.eclipse.swt.widgets.Display;

import cc71p.slotmachine.face.Logging;
import cc71p.slotmachine.model.NVRAM;


/**
 * 
 * <b>Aspecto que implementa funcionalidades de logging</b>
 * 
 *
 * 03-10-2010 - (Daniel Estévez G.): versión inicial  
 *
 */
privileged aspect Reporting {
	
	NVRAM ram;
	Logging ui;
	boolean isLogging;
	/**
	 * 
	 * Aspecto que captura nvram en el aspecto
	 *
	 * 23-09-2010 - (Daniel Estévez G.) - versión inicial
	 *
	 * @param ui
	 */
	after(NVRAM ram):this(ram)&&execution(NVRAM+.new(..)){
		this.ram=ram;
	}
	
	/**
	 * 
	 * Aspecto que captura ui de logging y boolean que verifica si se debe hacer logging
	 * o no
	 *
	 * 03-10-2010 - (Daniel Estévez G.) - versión inicial
	 *
	 * @param ui
	 */
	after(Logging ui):this(ui)&&execution(Logging+.new(..)){
		this.ui=ui;
		this.isLogging=ui.isLogging;
		ui.printDialogBox("iniciado dialog box.."+isLogging);
		
	}
	/**
	 * 
	 * Advice que inicia logging cada 10 segundos
	 *
	 * 23-09-2010 - (Daniel Estévez G.) - versión inicial
	 *
	 */
	after():call(Logging+.new(..)){
		if(!isLogging)
			return;
		
		ui.printDialogBox("Se muestran contenido de NVRAM cada 10 segundos...");
		Display.getCurrent().timerExec(10000, muestraLog());		
	}
	
	Thread muestraLog(){
		Thread t = new Thread(){
			@Override
			public void run() {
				String[]log = new String[ram._ram.size()];
				int i=0;
				for (Enumeration e = ram._ram.keys(); e.hasMoreElements(); ) {
		            Object obj = e.nextElement();
		            log[i]=ram._ram.get(obj).toString();
		            i++;
		        }
				ui.log(log);
					
				Thread aux=muestraLog();
				Display.getCurrent().timerExec(10000, aux);
			}
		};
		return t;
	}
	
	
	
}

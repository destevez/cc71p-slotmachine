package cc71p.slotmachine.face;

import java.util.Calendar;

import org.eclipse.swt.SWT;
import org.eclipse.swt.widgets.Button;
import org.eclipse.swt.widgets.Display;
import org.eclipse.swt.widgets.Event;
import org.eclipse.swt.widgets.Label;
import org.eclipse.swt.widgets.Listener;
import org.eclipse.swt.widgets.Shell;
import org.eclipse.swt.widgets.Text;

import cc71p.slotmachine.model.Cerradura;
import cc71p.slotmachine.model.Enclosure;

public class UIEnclosure {
	Text dialogBox;
	Display display;
	Enclosure enclosure;
	public Button abrir,cerrar,todo_bien,inicial,payback;
	private int buttonWidth=150, buttonHeight=100, dialogWidth=950,dialogHeight=600;
	public Label labelLampara;
	public UIEnclosure(Shell shell, Enclosure enclosure) {
		this.enclosure=enclosure;
		shell.setText("Enclosure");
		display=shell.getDisplay();
		int x=0,y=0;
		shell.setSize(dialogWidth, dialogHeight+buttonHeight);	
		labelLampara = new Label(shell, SWT.BORDER);
		labelLampara.setSize(buttonWidth, buttonHeight);
		labelLampara.setLocation(x, y);
		labelLampara.setText("Apagada");
		x+=buttonWidth;
		abrir = new Button(shell, SWT.PUSH);
		abrir.setSize(buttonWidth, buttonHeight);
		abrir.setText("Abrir Enclosure");
		abrir.setLocation(x, y);
		x+=buttonWidth;
		final Listener listenerAbrir = new Listener() {			
			@Override
			public void handleEvent(Event event) {
				abrir();						
			}
		};
		abrir.addListener(SWT.Selection, listenerAbrir);
		cerrar = new Button(shell, SWT.PUSH);
		cerrar.setSize(buttonWidth, buttonHeight);
		cerrar.setText("Cerrar Enclosure");
		cerrar.setLocation(x, y);
		x+=buttonWidth;
		final Listener listenerCerrar = new Listener() {
			
			@Override
			public void handleEvent(Event event) {
				cerrar();
				
			}
		};
		cerrar.addListener(SWT.Selection, listenerCerrar);
		
		todo_bien = new Button(shell, SWT.PUSH);
		todo_bien.setSize(buttonWidth, buttonHeight);
		todo_bien.setLocation(x, y);		
		todo_bien.setText("Todo bien");
		x+=buttonWidth;
		final Listener listenerTodoBien = new Listener() {
			
			@Override
			public void handleEvent(Event event) {
				girarLlave(Cerradura.TODO_BIEN);
				
			}
		};
		todo_bien.addListener(SWT.Selection, listenerTodoBien);
		
		inicial = new Button(shell, SWT.PUSH);
		inicial.setSize(buttonWidth, buttonHeight);
		inicial.setLocation(x, y);		
		inicial.setText("Inicial");
		x+=buttonWidth;
		final Listener listenerInicial = new Listener() {
			
			@Override
			public void handleEvent(Event event) {
				girarLlave(Cerradura.INICIAL);
				
			}
		};
		inicial.addListener(SWT.Selection, listenerInicial);
		
		payback = new Button(shell, SWT.PUSH);
		payback.setSize(buttonWidth, buttonHeight);
		payback.setLocation(x, y);		
		payback.setText("Payback");
		x+=buttonWidth;
		final Listener listenerPayBack = new Listener() {
			
			@Override
			public void handleEvent(Event event) {
				girarLlave(Cerradura.PAYBACK);
				
			}
		};
		payback.addListener(SWT.Selection, listenerPayBack);
		
		x=0;y+=buttonHeight;
		dialogBox = new Text(shell, SWT.MULTI|SWT.BORDER | SWT.H_SCROLL | SWT.V_SCROLL);
		dialogBox.setSize(dialogWidth-20, dialogHeight-40);
		dialogBox.setLocation(x, y);
		
	}
	
	/**
	 * 
	 * Enciende Lampara de Enclosure
	 *
	 * 18-09-2010 - (Daniel Estévez G.) - versión inicial
	 *
	 */
	public void abrir(){
		enclosure.open=true;
		//enclosure.lampara=Lampara.ENCENDIDA;
		//labelLampara.setText("Encendida");
	}
	/**
	 * 
	 * Apaga Lampara de enclosure
	 *
	 * 21-09-2010 - (Daniel Estévez G.) - versión inicial
	 *
	 */
	public void cerrar(){
		enclosure.open=false;
		//enclosure.lampara=Lampara.APAGADA;
		//labelLampara.setText("Apagada");
	}
	/**
	 * 
	 * Gira llave de cerradura
	 *
	 * 21-09-2010 - (Daniel Estévez G.) - versión inicial
	 *
	 * @param cerradura
	 */
	public void girarLlave(Cerradura cerradura){
		enclosure.cerradura=cerradura;
	}
	
	/**
	 * 
	 * Imprime en la dialog box un mensaje manteniendo los mensajes anteriores
	 * 
	 * Hace un append en la parte superior de la dialog box
	 * 
	 *
	 * 19-09-2010 - (Daniel Estévez G.) - versión inicial
	 *
	 * @param s texto a agregar
	 */
	public void printDialogBox(final String s){
		Thread t= new Thread(){
			public void run() {
				String texto = dialogBox.getText();
				texto=Calendar.getInstance().getTime()+"-"+s+"\n"+texto;
				dialogBox.setText(texto);
			};
		};
		display.asyncExec(t);
		
	}
}

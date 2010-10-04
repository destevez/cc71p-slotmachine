package cc71p.slotmachine.face;

import java.util.Calendar;

import org.eclipse.swt.SWT;
import org.eclipse.swt.widgets.Button;
import org.eclipse.swt.widgets.Display;
import org.eclipse.swt.widgets.Event;
import org.eclipse.swt.widgets.Listener;
import org.eclipse.swt.widgets.Shell;
import org.eclipse.swt.widgets.Text;

public class UIRecall {
	Text dialogBox;
	Display display;
	public Button iniciarRepeticion,avanzar;
	private int buttonWidth=150, buttonHeight=100, dialogWidth=900,dialogHeight=600;
	
	public UIRecall(Shell shell) {
		shell.setText("Recall");
		display=shell.getDisplay();
		int x=0,y=0;
		shell.setSize(dialogWidth, dialogHeight+buttonHeight);
		x+=buttonWidth;
		iniciarRepeticion = new Button(shell, SWT.PUSH);
		iniciarRepeticion.setSize(buttonWidth, buttonHeight);
		iniciarRepeticion.setText("Iniciar Repetición");
		iniciarRepeticion.setLocation(x, y);
		x+=buttonWidth;
		final Listener listenerRepeticion = new Listener() {			
			@Override
			public void handleEvent(Event event) {
				comenzarRepeticion();						
			}
		};
		iniciarRepeticion.addListener(SWT.Selection, listenerRepeticion);
		avanzar = new Button(shell, SWT.PUSH);
		avanzar.setSize(buttonWidth, buttonHeight);
		avanzar.setText("Avanzar");
		avanzar.setLocation(x, y);
		x+=buttonWidth;
		final Listener listenerAvanzar = new Listener() {
			
			@Override
			public void handleEvent(Event event) {
				avanzar();
				
			}
		};
		avanzar.addListener(SWT.Selection, listenerAvanzar);		
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
	public void comenzarRepeticion(){
		
	}
	/**
	 * 
	 * Apaga Lampara de enclosure
	 *
	 * 21-09-2010 - (Daniel Estévez G.) - versión inicial
	 *
	 */
	public void avanzar(){
		
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

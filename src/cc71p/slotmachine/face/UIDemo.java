package cc71p.slotmachine.face;

import java.util.Calendar;

import org.eclipse.swt.SWT;
import org.eclipse.swt.widgets.Button;
import org.eclipse.swt.widgets.Display;
import org.eclipse.swt.widgets.Event;
import org.eclipse.swt.widgets.Listener;
import org.eclipse.swt.widgets.Shell;
import org.eclipse.swt.widgets.Text;

public class UIDemo {
	Text dialogBox;
	Display display;
	public Button interrumpir,continuar;
	private int buttonWidth=150, buttonHeight=100, dialogWidth=900,dialogHeight=600;	
	public UIDemo(Shell shell) {
		shell.setText("Demo UI");
		display=shell.getDisplay();
		int x=0,y=0;
		shell.setSize(dialogWidth, dialogHeight+buttonHeight);
		x+=buttonWidth;
		interrumpir = new Button(shell, SWT.PUSH);
		interrumpir.setSize(buttonWidth, buttonHeight);
		interrumpir.setText("Interrumpir");
		interrumpir.setLocation(x, y);
		x+=buttonWidth;
		final Listener listenerInterrumpir = new Listener() {			
			@Override
			public void handleEvent(Event event) {
				interrumpir();						
			}
		};
		interrumpir.addListener(SWT.Selection, listenerInterrumpir);
		continuar = new Button(shell, SWT.PUSH);
		continuar.setSize(buttonWidth, buttonHeight);
		continuar.setText("Continuar");
		continuar.setLocation(x, y);
		x+=buttonWidth;
		final Listener listenerContinuar = new Listener() {
			
			@Override
			public void handleEvent(Event event) {
				continuar();
				
			}
		};
		continuar.addListener(SWT.Selection, listenerContinuar);		
		x=0;y+=buttonHeight;
		dialogBox = new Text(shell, SWT.MULTI|SWT.BORDER | SWT.H_SCROLL | SWT.V_SCROLL);
		dialogBox.setSize(dialogWidth-20, dialogHeight-40);
		dialogBox.setLocation(x, y);
		
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
	
	void continuar(){
		
	}
	void interrumpir(){
		
	}
}

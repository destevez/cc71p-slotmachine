package cc71p.slotmachine.test;

import java.lang.reflect.Field;

import cc71p.slotmachine.asp.SlotMachine;

public class Test {
public static void main(String[] args) {
	for(Field f:SlotMachine.class.getDeclaredFields()){
		System.out.println(f.getName());
	}
}
}

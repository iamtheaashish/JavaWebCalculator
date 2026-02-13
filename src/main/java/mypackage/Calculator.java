package mypackage;

import java.io.*;
import java.math.BigDecimal;
import java.math.RoundingMode;
import javax.servlet.*;
import javax.servlet.http.*;

public class Calculator extends HttpServlet {
    private static final String PARAM_NUMBER_1 = "n1";
    private static final String PARAM_NUMBER_2 = "n2";
    private static final String PARAM_OPERATION = "op";
    private static final String OP_ADD = "add";
    private static final String OP_SUBTRACT = "sub";
    private static final String OP_MULTIPLY = "mul";
    private static final String OP_DIVIDE = "div";

    public long addFucn(long first, long second) {
        return first + second;
    }
	
    public long subFucn(long first, long second) {
        return first - second;
    }
	
    public long mulFucn(long first, long second) {
        return first * second;
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        handleRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        handleRequest(request, response);
    }

    private void handleRequest(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html; charset=UTF-8");

        String input1 = safeTrim(request.getParameter(PARAM_NUMBER_1));
        String input2 = safeTrim(request.getParameter(PARAM_NUMBER_2));
        String operation = resolveOperation(request);

        request.setAttribute("input1", input1);
        request.setAttribute("input2", input2);
        request.setAttribute("op", operation);

        String error = null;
        String result = null;
        String operationLabel = null;

        if (!input1.isEmpty() || !input2.isEmpty() || operation != null) {
            try {
                BigDecimal number1 = parseNumber(input1, "first");
                BigDecimal number2 = parseNumber(input2, "second");

                if (operation == null) {
                    error = "Please choose an operation.";
                } else if (OP_ADD.equals(operation)) {
                    operationLabel = "Addition";
                    result = number1.add(number2).stripTrailingZeros().toPlainString();
                } else if (OP_SUBTRACT.equals(operation)) {
                    operationLabel = "Subtraction";
                    result = number1.subtract(number2).stripTrailingZeros().toPlainString();
                } else if (OP_MULTIPLY.equals(operation)) {
                    operationLabel = "Multiplication";
                    result = number1.multiply(number2).stripTrailingZeros().toPlainString();
                } else if (OP_DIVIDE.equals(operation)) {
                    if (number2.compareTo(BigDecimal.ZERO) == 0) {
                        error = "Cannot divide by zero.";
                    } else {
                        operationLabel = "Division";
                        result = number1.divide(number2, 10, RoundingMode.HALF_UP)
                                .stripTrailingZeros().toPlainString();
                    }
                } else {
                    error = "Unknown operation.";
                }
            } catch (IllegalArgumentException ex) {
                error = ex.getMessage();
            } catch (Exception ex) {
                error = "Something went wrong. Please try again.";
            }
        }

        request.setAttribute("result", result);
        request.setAttribute("operationLabel", operationLabel);
        request.setAttribute("error", error);

        RequestDispatcher dispatcher = request.getRequestDispatcher("/index.jsp");
        dispatcher.forward(request, response);
    }

    private String resolveOperation(HttpServletRequest request) {
        String op = safeTrim(request.getParameter(PARAM_OPERATION));
        if (!op.isEmpty()) {
            return op;
        }
        if (request.getParameter("r1") != null) {
            return OP_ADD;
        }
        if (request.getParameter("r2") != null) {
            return OP_SUBTRACT;
        }
        if (request.getParameter("r3") != null) {
            return OP_MULTIPLY;
        }
        return null;
    }

    private BigDecimal parseNumber(String value, String label) {
        if (value.isEmpty()) {
            throw new IllegalArgumentException("Please enter the " + label + " number.");
        }
        try {
            return new BigDecimal(value);
        } catch (NumberFormatException ex) {
            throw new IllegalArgumentException("Please enter a valid " + label + " number.");
        }
    }

    private String safeTrim(String value) {
        return value == null ? "" : value.trim();
    }
}

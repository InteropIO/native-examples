// Machine generated IDispatch wrapper class(es) created with Add Class from Typelib Wizard

#include <afxdisp.h>

#import "C:\\work\\tick42\\stash\\dot-net-glue-com\\GlueCom\\bin\\Debug\\GlueCOM.dll" no_namespace
// CGlueNameValuePair wrapper class

class CGlueNameValuePair : public COleDispatchDriver
{
public:
	CGlueNameValuePair() {} // Calls COleDispatchDriver default constructor
	CGlueNameValuePair(LPDISPATCH pDispatch) : COleDispatchDriver(pDispatch) {}
	CGlueNameValuePair(const CGlueNameValuePair& dispatchSrc) : COleDispatchDriver(dispatchSrc) {}

	// Attributes
public:

	// Operations
public:


	// IGlueNameValuePair methods
public:
	CString get_Name()
	{
		CString result;
		InvokeHelper(0x60020000, DISPATCH_PROPERTYGET, VT_BSTR, (void*)&result, nullptr);
		return result;
	}
	VARIANT get_Value()
	{
		VARIANT result;
		InvokeHelper(0x0, DISPATCH_PROPERTYGET, VT_VARIANT, (void*)&result, nullptr);
		return result;
	}

	// IGlueNameValuePair properties
public:

};

// Machine generated IDispatch wrapper class(es) created with Add Class from Typelib Wizard

#import "C:\\work\\tick42\\stash\\dot-net-glue-com\\GlueCom\\bin\\Debug\\GlueCOM.dll" no_namespace
// CGlueValueCollection wrapper class

class CGlueValueCollection : public COleDispatchDriver
{
public:
	CGlueValueCollection() {} // Calls COleDispatchDriver default constructor
	CGlueValueCollection(LPDISPATCH pDispatch) : COleDispatchDriver(pDispatch) {}
	CGlueValueCollection(const CGlueValueCollection& dispatchSrc) : COleDispatchDriver(dispatchSrc) {}

	// Attributes
public:

	// Operations
public:


	// IGlueValueCollection methods
public:
	LPUNKNOWN GetEnumerator()
	{
		LPUNKNOWN result;
		InvokeHelper(0xfffffffc, DISPATCH_METHOD, , (void*)&result, nullptr);
		return result;
	}
	VARIANT get__Default(VARIANT& key)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT;
		InvokeHelper(0x0, DISPATCH_PROPERTYGET, VT_VARIANT, (void*)&result, parms, &key);
		return result;
	}
	long get_Count()
	{
		long result;
		InvokeHelper(0x60020002, DISPATCH_PROPERTYGET, VT_I4, (void*)&result, nullptr);
		return result;
	}
	SAFEARRAY * get_Names()
	{
		SAFEARRAY * result;
		InvokeHelper(0x60020003, DISPATCH_PROPERTYGET, , (void*)&result, nullptr);
		return result;
	}
	SAFEARRAY * get_Values()
	{
		SAFEARRAY * result;
		InvokeHelper(0x60020004, DISPATCH_PROPERTYGET, , (void*)&result, nullptr);
		return result;
	}
	BOOL Contains(LPCTSTR Name)
	{
		BOOL result;
		static BYTE parms[] = VTS_BSTR;
		InvokeHelper(0x60020005, DISPATCH_METHOD, VT_BOOL, (void*)&result, parms, Name);
		return result;
	}

	// IGlueValueCollection properties
public:

};

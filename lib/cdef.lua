shell32 = ffi.load("shell32")
user32 = ffi.load("user32")
WININET = ffi.load("wininet")

ffi.cdef [[
    typedef char CHAR;
    typedef unsigned long ULONG;
    typedef unsigned int UINT;

    typedef int BOOL;
    typedef uint32_t DWORD;

    typedef void* HANDLE;
    typedef void* HINTERNET;

    typedef char* LPSTR;
    typedef const char* LPCSTR;

    int GetSystemMetrics(int nIndex);
    short GetAsyncKeyState(int vKey);

    BOOL SystemParametersInfoA(
        DWORD uiAction,
        DWORD uiParam,
        void* pvParam,
        DWORD fWinIni
    );

    typedef struct _FILETIME {
        DWORD dwLowDateTime;
        DWORD dwHighDateTime;
    } FILETIME, *PFILETIME, *LPFILETIME;

    typedef struct _WIN32_FIND_DATAA {
        DWORD dwFileAttributes;
        FILETIME ftCreationTime;
        FILETIME ftLastAccessTime;
        FILETIME ftLastWriteTime;
        DWORD nFileSizeHigh;
        DWORD nFileSizeLow;
        DWORD dwReserved0;
        DWORD dwReserved1;
        CHAR cFileName[260];
        CHAR cAlternateFileName[14];
    } WIN32_FIND_DATAA, *PWIN32_FIND_DATAA, *LPWIN32_FIND_DATAA;
    
    typedef struct {
        DWORD cbSize;
        ULONG fMask;
        HANDLE hwnd;
        LPCSTR lpVerb;
        LPCSTR lpFile;
        LPCSTR lpParameters;
        LPCSTR lpDirectory;
        int nShow;
        HANDLE hInstApp;
        void* lpIDList;
        LPCSTR lpClass;
        HANDLE hkeyClass;
        DWORD dwHotKey;
        union {
            HANDLE hIcon;
            HANDLE hMonitor;
        } DUMMYUNIONNAME;
        HANDLE hProcess;
    } SHELLEXECUTEINFOA, *LPSHELLEXECUTEINFOA;

    DWORD GetLastError();

    HANDLE FindFirstFileA(LPCSTR lpFileName, LPWIN32_FIND_DATAA lpFindFileData);
    BOOL FindNextFileA(HANDLE hFindFile, LPWIN32_FIND_DATAA lpFindFileData);
    BOOL FindClose(HANDLE hFindFile);

    BOOL ShellExecuteExA(LPSHELLEXECUTEINFOA lpExecInfo);
  
    HINTERNET InternetOpenA(LPCSTR, DWORD, LPCSTR, LPCSTR, DWORD);
    HINTERNET InternetOpenUrlA(HINTERNET, LPCSTR, LPCSTR, DWORD, DWORD, DWORD);
    UINT InternetReadFile(HINTERNET, LPSTR, UINT, UINT*);
    BOOL InternetCloseHandle(HINTERNET);
]]

SPI_GETWHEELSCROLLLINES = 0x0068
INVALID_HANDLE_VALUE = ffi.cast('void*', -1)
SEE_MASK_NOCLOSEPROCESS = 0x00000040
SW_SHOW = 5
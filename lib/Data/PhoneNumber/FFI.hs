{-# LANGUAGE ForeignFunctionInterface #-}

module Data.PhoneNumber.FFI (
    PhoneNumberRef(..),
    PhoneNumberUtil(..),

    -- * Parsing and utility
    c_phone_number_ctor,
    c_phone_number_dtor,
    c_phone_number_util_get_instance,
    c_phone_number_util_parse,

    c_phone_number_has_country_code,
    c_phone_number_has_national_number,
    c_phone_number_has_extension,
    c_phone_number_get_country_code,
    c_phone_number_get_national_number,
    c_phone_number_get_extension,
    -- * Accessors
) where

import           Foreign.C.String   (CString)
import           Foreign.C.Types    (CInt (..), CULLong (..))
import           Foreign.ForeignPtr (ForeignPtr)
import           Foreign.Ptr        (FunPtr, Ptr)

-- | An opaque pointer to a PhoneNumberRef C++ class
data PhoneNumberRef = PhoneNumberRef { unPhoneNumberRef :: ForeignPtr PhoneNumberRef }
  deriving Show

-- | An opaque pointer to the (singleton) PhoneNumberUtil C++ class
data PhoneNumberUtil = PhoneNumberUtil { unPhoneNumberUtil :: Ptr PhoneNumberUtil }
  deriving Show

--  | Create a PhoneNumber opaque pointer
foreign import ccall unsafe "c-phone-numbers.h _c_phone_number_ctor"
    c_phone_number_ctor
        :: IO (Ptr PhoneNumberRef)

--  | Destroy a PhoneNumber
foreign import ccall unsafe "c-phone-numbers.h &_c_phone_number_dtor"
    c_phone_number_dtor
        :: FunPtr (Ptr PhoneNumberRef -> IO ())

--  | Get the singleton PhoneNumberUtil opaque pointer
foreign import ccall unsafe "c-phone-numbers.h _c_phone_number_util_get_instance"
    c_phone_number_util_get_instance ::
        IO (Ptr PhoneNumberUtil)

-- | Call a C wrapper to parse a phone number with explicit length strings
foreign import ccall unsafe "c-phone-numbers.h _c_phone_number_util_parse"
    c_phone_number_util_parse
        :: Ptr PhoneNumberUtil
        -> CString
        -> CInt
        -- ^ The phone number
        -> CString
        -> CInt
        -- ^ The region code (AU, US, etc)
        -> Ptr PhoneNumberRef
        -- ^ The pointer to write to
        -> IO CInt

foreign import ccall unsafe "c-phone-numbers.h _c_phone_number_has_country_code"
    c_phone_number_has_country_code
        :: Ptr PhoneNumberRef
        -> IO Bool

foreign import ccall unsafe "c-phone-numbers.h _c_phone_number_has_national_number"
    c_phone_number_has_national_number
        :: Ptr PhoneNumberRef
        -> IO Bool

foreign import ccall unsafe "c-phone-numbers.h _c_phone_number_has_extension"
    c_phone_number_has_extension
        :: Ptr PhoneNumberRef
        -> IO Bool

foreign import ccall unsafe "c-phone-numbers.h _c_phone_number_get_country_code"
    c_phone_number_get_country_code
        :: Ptr PhoneNumberRef
        -> IO CULLong

foreign import ccall unsafe "c-phone-numbers.h _c_phone_number_get_national_number"
    c_phone_number_get_national_number
        :: Ptr PhoneNumberRef
        -> IO CULLong

foreign import ccall unsafe "c-phone-numbers.h _c_phone_number_get_extension"
    c_phone_number_get_extension
        :: Ptr PhoneNumberRef
        -> IO CString
import os


class Settings:
    """
    Application configuration.

    CUSTOMER_BACKEND controls which Customer backend is used.
    Supported values: modern, memory, legacy.
    """

    def __init__(self):
        self.customer_backend = os.getenv(
            "CUSTOMER_BACKEND",
            "modern",
        ).lower()

        self.zos_connect_base_url = os.getenv(
            "ZOS_CONNECT_BASE_URL",
            "http://localhost:9080",
        )

        self.zos_connect_timeout = float(
            os.getenv(
                "ZOS_CONNECT_TIMEOUT",
                "10",
            )
        )

        self.zos_connect_verify_tls = os.getenv(
            "ZOS_CONNECT_VERIFY_TLS",
            "true",
        ).lower() == "true"


settings = Settings()

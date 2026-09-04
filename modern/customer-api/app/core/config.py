import os


class Settings:
    """
    Application configuration.

    CUSTOMER_BACKEND controls which Customer backend is used.
    Supported values currently: modern, memory.
    """

    def __init__(self):
        self.customer_backend = os.getenv(
            "CUSTOMER_BACKEND",
            "modern",
        ).lower()


settings = Settings()

#!/usr/bin/env python3
from argparse import ArgumentParser
from datetime import datetime, timedelta
from jwt import encode
from os import system


class NotificationAgentClaim:
    def __init__(self, expiration_in_seconds: int) -> None:
        self.sub = 'notification-agent'
        self.iss = 'mac-at-ibm'
        self.exp = datetime.utcnow() + timedelta(seconds=expiration_in_seconds)


class JwtGenerator:
    _ALGORITHM = 'RS256'

    def __init__(self, path_to_private_key: str, expiration_time: int):
        self.key = path_to_private_key
        self.expiration = expiration_time

    @property
    def key(self) -> str:
        return self._key

    @key.setter
    def key(self, path_to_key_file: str) -> None:
        file = open(path_to_key_file, 'r')
        if file.mode == 'r':
            self._key = file.read()
        else:
            raise ValueError('missing or invalid private key')

    @property
    def expiration(self) -> int:
        return self._expiration

    @expiration.setter
    def expiration(self, value: int) -> None:
        if value < 1:
            raise ValueError('Expiration below 1 is illegal')
        self._expiration = value

    def generate(self) -> str:
        payload = NotificationAgentClaim(self.expiration)
        return encode(payload.__dict__, key=self.key, algorithm=self._ALGORITHM).decode('utf-8')


def parse_args():
    arg_parser = ArgumentParser(prog='jwtgenerator',
                                description='Generates signed JWT token for Mac@IBM Notifications',
                                allow_abbrev=False)

    arg_parser.add_argument('key',
                            action='store',
                            metavar='private-key',
                            help='path to RS256 private key file')

    arg_parser.add_argument('-e',
                            '--expires-in',
                            action='store',
                            type=int,
                            default=600,
                            dest='expiration_in_seconds',
                            metavar='SECONDS',
                            help='JWT expiration time in seconds (default 60)')
    return arg_parser.parse_args()


def main() -> None:
    args = parse_args()
    generator = JwtGenerator(path_to_private_key=args.key, expiration_time=args.expiration_in_seconds)
    print(generator.generate())


if __name__ == "__main__":
    main()
